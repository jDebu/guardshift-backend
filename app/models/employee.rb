class Employee < ApplicationRecord
  has_many :shifts
  has_many :availabilities

  validates :name, :color, presence: true
end
