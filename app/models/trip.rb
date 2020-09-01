class Trip < ApplicationRecord
  belongs_to :user

  belongs_to :origin, :class_name => 'Country'
  belongs_to :destination, :class_name => 'Country'
end
