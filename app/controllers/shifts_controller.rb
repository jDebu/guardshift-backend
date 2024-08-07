class ShiftsController < ApplicationController
  before_action :validate_date_range, only: :index

  def index
    @start_date = Date.parse(shifts_params[:start_date])
    @end_date = Date.parse(shifts_params[:end_date])
    @service_id = shifts_params[:service_id]

    employees = Employee.order(:id).select(:id, :name, :color)
    employee_counts = employees.each_with_object({}) { |e, h| h[e.id] = { name: e.name, total: 0, color: e.color } }
    days = []
    total_unassigned = 0
    message = ''

    if params[:auto_assign].present? && params[:auto_assign] == 'true'
      if auto_assign_shifts(employee_counts.deep_dup)
        message = 'No hay turnos disponibles para calcular turnos.'
      end
    end

    (@start_date..@end_date).each do |date|
      day_name = I18n.l(date, format: :default)
      time_blocks = TimeBlock.where(date: date, blockable_type: 'Shift').includes(blockable: :employee)
      time_blocks = time_blocks.joins("INNER JOIN shifts ON shifts.id = time_blocks.blockable_id AND time_blocks.blockable_type = 'Shift'")
      time_blocks = time_blocks.joins("INNER JOIN services ON services.id = shifts.service_id")
      time_blocks = time_blocks.where("services.id = ?", @service_id) if @service_id.present?
      time_blocks = time_blocks.sort_by { |tb| [tb.start_time.hour, tb.start_time.min] }

      next if time_blocks.empty?

      first_time_block = time_blocks.first
      last_time_block = time_blocks.last

      ranges = {}
      last_time_block_end_time = (last_time_block.end_time.hour - 1) % 24
      (first_time_block.start_time.hour..last_time_block_end_time).each do |hour|
        next_hour = (hour + 1) % 24
        range_key = "#{format('%02d', hour)}:00-#{format('%02d', next_hour)}:00"
        ranges[range_key] = { 'employee_name': nil, color: '#fff' }
      end

      time_blocks.each do |block|
        range_key = "#{block.start_time.strftime('%H:%M')}-#{block.end_time.strftime('%H:%M')}"
        employee_data = block.blockable.employee
        ranges[range_key][:employee_name] = employee_data.name
        ranges[range_key][:color] = employee_data.color
        employee_id = block.blockable.employee.id
        employee_counts[employee_id][:total] += 1 if employee_counts[employee_id]
      end

      formatted_ranges = ranges.map do |title, shift|
        range = { title: title, employee_name: shift[:employee_name], color: shift[:color] }
        total_unassigned += 1 if shift[:employee_name].nil?
        range
      end
      days << { date: date, name: day_name, ranges: formatted_ranges }
    end

    employee_totals = employee_counts.map { |id, data| { id: id, name: data[:name], total: data[:total], color: data[:color] } }

    render json: {
      start_date: shifts_params[:start_date],
      end_date: shifts_params[:end_date],
      total_unassigned: total_unassigned,
      employees: employee_totals,
      days: days,
      message: message
    }
  end

  def weeks
    start_date = Date.commercial(2020, 10, 1)
    weeks = []

    5.times do |i|
      week_start = start_date + (i * 7)
      week_end = week_start + 6
      label = "Semana #{week_start.cweek} del #{week_start.year}"
      value = "#{week_start} #{week_end}"
      value_name = "del #{week_start.strftime('%d/%m/%Y')} al #{week_end.strftime('%d/%m/%Y')}"
      weeks << { label: label, value: value, value_name: value_name }
    end

    render json: { weeks: weeks }
  end

  private

  def shifts_params
    params.permit(:start_date, :end_date, :service_id, :auto_assign)
  end

  def validate_date_range
    unless shifts_params[:start_date].present? && shifts_params[:end_date].present?
      render json: { error: 'Missing required parameters: start_date and end_date' }, status: :bad_request
    end
  rescue ArgumentError
    render json: { error: 'Invalid date format. Use YYYY-MM-DD' }, status: :bad_request
  end

  def auto_assign_shifts(employee_counts)
    availabilities = Availability.where(date: @start_date..@end_date, service_id: @service_id).includes(:employee)
    return true if availabilities.empty?
    shifts = []

    availabilities.each do |availability|
      employee = availability.employee
      employee_counts[employee.id][:name] = employee.name
      employee_counts[employee.id][:color] = employee.color
    end

    (@start_date..@end_date).each do |date|
      availabilities_for_date = availabilities.select { |a| a.date == date }
      availabilities_for_date.sort_by! { |a| [a.start_time, a.end_time] }

      availabilities_for_date.each do |availability|
        employee = availability.employee

        shift = shifts.find { |s| s.date == date && s.employee_id == employee.id && s.end_time == availability.start_time }
        if shift
          shift.end_time = availability.end_time
          shift.save
        else
          shift = Shift.create!(
            service_id: @service_id,
            employee_id: employee.id,
            date: date,
            start_time: availability.start_time,
            end_time: availability.end_time
          )
          shifts << shift
        end

        employee_counts[employee.id][:total] += 1
      end
    end

    total_shifts = shifts.size
    ideal_shifts_per_employee = total_shifts / employee_counts.size

    over_assigned_employees = employee_counts.select { |_, data| data[:total] > ideal_shifts_per_employee }
    under_assigned_employees = employee_counts.select { |_, data| data[:total] < ideal_shifts_per_employee }

    over_assigned_employees.each do |employee_id, data|
      shifts_to_reassign = data[:total] - ideal_shifts_per_employee
      shifts_for_employee = shifts.select { |s| s.employee_id == employee_id }

      shifts_for_employee.last(shifts_to_reassign).each do |shift|
        under_assigned_employee = under_assigned_employees.keys.sample
        next unless employee_counts[under_assigned_employee]

        shift.update(employee_id: under_assigned_employee)
        employee_counts[employee_id][:total] -= 1
        employee_counts[under_assigned_employee][:total] += 1

        under_assigned_employees.delete(under_assigned_employee) if employee_counts[under_assigned_employee][:total] == ideal_shifts_per_employee
      end
    end
    false
  end
end
