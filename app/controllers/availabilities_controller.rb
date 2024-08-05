class AvailabilitiesController < ApplicationController
  before_action :validate_date_range, only: :index

  def index
    start_date = Date.parse(availabilities_params[:start_date])
    end_date = Date.parse(availabilities_params[:end_date])

    employees = Employee.order(:id).select(:id, :name)
    days = []

    (start_date..end_date).each do |date|
      day_name = date.strftime('%A %d de %B')
      time_blocks = TimeBlock.where(date: date, blockable_type: 'Availability')
      time_blocks = time_blocks.sort_by { |tb| [tb.start_time.hour, tb.start_time.min] }

      next if time_blocks.empty?

      first_time_block = time_blocks.first
      last_time_block = time_blocks.last

      ranges = {}
      last_time_block_end_time = (last_time_block.end_time.hour - 1) % 24
      (first_time_block.start_time.hour..last_time_block_end_time).each do |hour|
        next_hour = (hour + 1) % 24
        range_key = "#{format('%02d', hour)}:00-#{format('%02d', next_hour)}:00"
        ranges[range_key] = Hash[employees.map { |e| [e.id.to_s, false] }]
      end

      time_blocks.each do |block|
        range_key = "#{block.start_time.strftime('%H:%M')}-#{block.end_time.strftime('%H:%M')}"
        # debugger
        ranges[range_key][block.blockable.employee_id.to_s] = true
      end

      # debugger
      formatted_ranges = ranges.map do |title, availability|
        range = { title: title }
        any_available = false
        availability.each do |employee_id, available|
          range[employee_id] = available
          any_available ||= available
        end
        range[:available] = any_available
        range
      end
      # debugger
      days << { date: date, name: day_name, ranges: formatted_ranges }
    end

    render json: {
      start_date: availabilities_params[:start_date],
      end_date: availabilities_params[:end_date],
      employees: employees,
      days: days
    }
  end
  
  private

  def availabilities_params
    params.permit(:start_date, :end_date)
  end

  def validate_date_range
    unless availabilities_params[:start_date].present? && availabilities_params[:end_date].present?
      render json: { error: 'Missing required parameters: start_date and end_date' }, status: :bad_request
    end
  rescue ArgumentError
    render json: { error: 'Invalid date format. Use YYYY-MM-DD' }, status: :bad_request
  end
end
