class Trip < ApplicationRecord
  belongs_to :user, optional: true

  belongs_to :origin, :class_name => 'Country'
  belongs_to :destination, :class_name => 'Country'

  has_many :notifications
end
