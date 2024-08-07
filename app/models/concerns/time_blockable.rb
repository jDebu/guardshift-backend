module TimeBlockable
  extend ActiveSupport::Concern

  included do
    belongs_to :employee
    belongs_to :service

    has_many :time_blocks, as: :blockable, dependent: :destroy

    validates :date, :start_time, :end_time, presence: true

    after_create :create_time_blocks
  end

  private

  def create_time_blocks
    end_hour = (end_time.hour - 1) % 24
    if self.is_a?(Shift)
      create_shift_time_blocks(end_hour)
    else
      create_standard_time_blocks(end_hour)
    end
  end

  def create_standard_time_blocks(end_hour)
    (start_time.hour..end_hour).each do |hour|
      start_time_obj = Time.zone.parse("#{hour}:00")
      end_time_obj = Time.zone.parse("#{(hour + 1) % 24}:00")

      TimeBlock.create!(
        date: date,
        start_time: start_time_obj,
        end_time: end_time_obj,
        blockable: self
      )
    end
  end

  def create_shift_time_blocks(end_hour)
    success = true
    ActiveRecord::Base.transaction do
      (start_time.hour..end_hour).each do |hour|
        start_time_obj = Time.zone.parse("#{hour}:00")
        end_time_obj = Time.zone.parse("#{hour + 1 == 24 ? 0 : hour + 1}:00")

        availability_block = find_availability_block(start_time_obj, end_time_obj)

        if availability_block.nil?
          success = false
          raise ActiveRecord::Rollback, "No available time block for #{employee.name} on #{date} from #{start_time_obj.strftime("%H:%M")} to #{end_time_obj.strftime("%H:%M")}"
        end

        TimeBlock.create!(
          date: date,
          start_time: start_time_obj,
          end_time: end_time_obj,
          blockable: self,
          availability_time_block: availability_block
        )
      end
    end
    destroy unless success
  end

  def find_availability_block(start_time_obj, end_time_obj)
    availability_blocks = TimeBlock.where(
      date: date,
      start_time: start_time_obj,
      end_time: end_time_obj,
      blockable_type: 'Availability'
    )

    availability_blocks.find do |block|
      block.blockable.employee_id == employee_id && block.blockable.service_id == service_id
    end
  end
end
