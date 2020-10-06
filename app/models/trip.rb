class Trip < ApplicationRecord
  belongs_to :user, optional: true

  belongs_to :origin, :class_name => 'Country'
  belongs_to :destination, :class_name => 'Country'

  has_many :notifications

  validates :new_daily_cases_thresholds, numericality: { greater_than_or_equal_to: 0 }
end
