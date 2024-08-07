class AvailabilitiesController < ApplicationController
  before_action :validate_date_range, only: :index

  def index
    start_date = Date.parse(availabilities_params[:start_date])
    end_date = Date.parse(availabilities_params[:end_date])
    service_id = availabilities_params[:service_id]

    service = Service.find_by_id(service_id) if  service_id.present?
    employees = Employee.order(:id).select(:id, :name, :color)
    days = []

    (start_date..end_date).each do |date|
      day_name = I18n.l(date, format: :default)
      time_blocks = TimeBlock.where(date: date, blockable_type: 'Availability')
      time_blocks = time_blocks.joins("INNER JOIN availabilities ON availabilities.id = time_blocks.blockable_id AND time_blocks.blockable_type = 'Availability'")
      time_blocks = time_blocks.joins("INNER JOIN services ON services.id = availabilities.service_id")
      time_blocks = time_blocks.where("services.id = ?", service_id) if service_id.present?
      time_blocks = time_blocks.sort_by { |tb| [tb.start_time.hour, tb.start_time.min] }

      ranges = {}

      if date.wday.between?(1, 5)
        first_time_block_start_time = service.week_start_time.hour
        last_time_block_end_time = (service.week_end_time.hour - 1) % 24
      else
        first_time_block_start_time = service.weekend_start_time.hour
        last_time_block_end_time = (service.weekend_end_time.hour - 1) % 24
      end

      (first_time_block_start_time..last_time_block_end_time).each do |hour|
        next_hour = (hour + 1) % 24
        range_key = "#{format('%02d', hour)}:00-#{format('%02d', next_hour)}:00"
        ranges[range_key] = Hash[employees.map { |e| [e.id.to_s, { available: false, block_id: nil, block_shift_id: nil }] }]
      end

      time_blocks.each do |block|
        range_key = "#{block.start_time.strftime('%H:%M')}-#{block.end_time.strftime('%H:%M')}"
        ranges[range_key][block.blockable.employee_id.to_s] = {
          available: true,
          block_id: block.id,
          block_shift_id: block.shift_time_block&.id || nil
        }
      end

      formatted_ranges = ranges.map do |title, availability|
        range = { title: title }
        any_available = false
        availability.each do |employee_id, avail_data|
          range[employee_id] = avail_data
          any_available ||= avail_data[:available]
        end
        range[:available] = any_available
        range
      end

      days << { date: date, name: day_name, ranges: formatted_ranges }
    end

    render json: {
      start_date: availabilities_params[:start_date],
      end_date: availabilities_params[:end_date],
      employees: employees,
      days: days
    }
  end

  def create
    service_id = params[:service_id]
    employee_id = params[:employee_id]
    date = Date.parse(params[:date])
    start_time = Time.parse(params[:start_time])
    end_time = Time.parse(params[:end_time])
    block_id = params[:block_id]
    block_shift_id = params[:block_shift_id]

    if block_id.present? && block_shift_id.present?
      TimeBlock.find_by(id: block_shift_id).destroy
      TimeBlock.find_by(id: block_id).destroy
      render json: { message: "TimeBlocks eliminados con éxito" }, status: :ok
    elsif block_id.present? && block_shift_id.nil?
      TimeBlock.find_by(id: block_id).destroy
      render json: { message: "TimeBlock eliminado con éxito" }, status: :ok
    else
      availability = Availability.find_by(service_id: service_id, employee_id: employee_id, date: date)
      if availability.present?
        if availability.can_concatenate?(start_time, end_time)
          availability.concatenate(start_time, end_time)
          render json: availability, status: :ok
        else
          create_new_availability(service_id, employee_id, date, start_time, end_time)
        end
      else
        create_new_availability(service_id, employee_id, date, start_time, end_time)
      end
    end
  end
  
  private

  def availabilities_params
    params.permit(:start_date, :end_date, :service_id)
  end

  def validate_date_range
    unless availabilities_params[:start_date].present? && availabilities_params[:end_date].present?
      render json: { error: 'Missing required parameters: start_date and end_date' }, status: :bad_request
    end
  rescue ArgumentError
    render json: { error: 'Invalid date format. Use YYYY-MM-DD' }, status: :bad_request
  end

  def create_new_availability(service_id, employee_id, date, start_time, end_time)
    new_availability = Availability.create(
      service_id: service_id,
      employee_id: employee_id,
      date: date,
      start_time: start_time,
      end_time: end_time
    )
    if new_availability.persisted?
      render json: new_availability, status: :created
    else
      render json: new_availability.errors, status: :unprocessable_entity
    end
  end
end
