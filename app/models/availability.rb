class Availability < ApplicationRecord
  belongs_to :employee
  belongs_to :service

  validates :date, :start_time, :end_time, presence: true
end
