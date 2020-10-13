class AddNotifyToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :notify, :boolean
  end
end
