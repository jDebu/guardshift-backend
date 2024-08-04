class TimeBlock < ApplicationRecord
  belongs_to :blockable, polymorphic: true
  belongs_to :availability_time_block, class_name: 'TimeBlock', optional: true

  validates :date, :start_time, :end_time, presence: true
end
