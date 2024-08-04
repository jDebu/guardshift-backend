class Shift < ApplicationRecord
  belongs_to :employee
  belongs_to :service

  validates :start_time, :end_time, presence: true
end
