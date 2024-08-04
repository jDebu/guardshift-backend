class Service < ApplicationRecord
  has_many :shifts
  has_many :availabilities

  validates :name, :week_start_time, :week_end_time, :weekend_start_time, :weekend_end_time, presence: true
end
