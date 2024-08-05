class ShiftsController < ApplicationController
  before_action :validate_date_range, only: :index

  def index
    start_date = Date.parse(shifts_params[:start_date])
    end_date = Date.parse(shifts_params[:end_date])
  
    employees = Employee.order(:id).select(:id, :name)
    employee_counts = employees.each_with_object({}) { |e, h| h[e.id] = { name: e.name, total: 0, color: e.color } }
    days = []
    total_unassigned = 0
  
    (start_date..end_date).each do |date|
      day_name = date.strftime('%A %d de %B')
      time_blocks = TimeBlock.where(date: date, blockable_type: 'Shift').includes(blockable: :employee)
      time_blocks = time_blocks.sort_by { |tb| [tb.start_time.hour, tb.start_time.min] }
  
      next if time_blocks.empty?
  
      first_time_block = time_blocks.first
      last_time_block = time_blocks.last
  
      ranges = {}
      last_time_block_end_time = (last_time_block.end_time.hour - 1) % 24
      (first_time_block.start_time.hour..last_time_block_end_time).each do |hour|
        next_hour = (hour + 1) % 24
        range_key = "#{format('%02d', hour)}:00-#{format('%02d', next_hour)}:00"
        ranges[range_key] = { 'employee_name': '' }
      end
  
      time_blocks.each do |block|
        range_key = "#{block.start_time.strftime('%H:%M')}-#{block.end_time.strftime('%H:%M')}"
        employee_name = block.blockable.employee.name
        ranges[range_key][:employee_name] = employee_name
        employee_id = block.blockable.employee.id
        employee_counts[employee_id][:total] += 1 if employee_counts[employee_id]
      end
  
      formatted_ranges = ranges.map do |title, shift|
        range = { title: title, employee_name: shift[:employee_name] }
        total_unassigned += 1 if shift[:employee_name].empty?
        range
      end
      days << { date: date, name: day_name, ranges: formatted_ranges }
    end
  
    employee_totals = employee_counts.map { |id, data| { id: id, name: data[:name], total: data[:total] } }
  
    render json: {
      start_date: shifts_params[:start_date],
      end_date: shifts_params[:end_date],
      total_unassigned: total_unassigned,
      employees: employee_totals,
      days: days
    }
  end
  
  private

  def shifts_params
    params.permit(:start_date, :end_date)
  end

  def validate_date_range
    unless shifts_params[:start_date].present? && shifts_params[:end_date].present?
      render json: { error: 'Missing required parameters: start_date and end_date' }, status: :bad_request
    end
  rescue ArgumentError
    render json: { error: 'Invalid date format. Use YYYY-MM-DD' }, status: :bad_request
  end
end