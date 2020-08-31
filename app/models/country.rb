class Country < ApplicationRecord
  has_many :cases
  has_many :indications

  has_many :trips_as_destination, :class_name => 'Trip', :foreign_key => 'destination_id', dependent: :destroy
  has_many :trips_as_origin, :class_name => 'Trip', :foreign_key => 'origin_id', dependent: :destroy
  has_many :users
end
