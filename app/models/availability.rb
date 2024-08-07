class Availability < ApplicationRecord
  include TimeBlockable

  def can_concatenate?(new_start_time, new_end_time)
    (new_start_time.strftime("%H:%M") == end_time.strftime("%H:%M") || new_end_time.strftime("%H:%M") == start_time.strftime("%H:%M"))
  end

  def concatenate(new_start_time, new_end_time)
    transaction do
      time_blocks.destroy_all

      if new_start_time.strftime("%H:%M") == end_time.strftime("%H:%M")
        self.end_time = new_end_time
      elsif new_end_time.strftime("%H:%M") == start_time.strftime("%H:%M")
        self.start_time = new_start_time
      end

      save!
      create_time_blocks
    end
  end
end
