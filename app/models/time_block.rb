class TimeBlock < ApplicationRecord
  belongs_to :blockable, polymorphic: true
  belongs_to :availability_time_block, class_name: 'TimeBlock', optional: true

  validates :date, :start_time, :end_time, presence: true
  has_one :shift_time_block, -> { where(blockable_type: 'Shift') }, class_name: 'TimeBlock', foreign_key: :availability_time_block_id
end
