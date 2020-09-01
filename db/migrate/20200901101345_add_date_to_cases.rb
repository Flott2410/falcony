class AddDateToCases < ActiveRecord::Migration[6.0]
  def change
    # will default to current day and follow the patter yyyy-mm-dd
    add_column :cases, :date, :date, default: Time.new.strftime('%Y-%m-%d'), null: false
  end
end
