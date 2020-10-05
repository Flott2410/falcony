class AddNewDailyCasesThresholdToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :new_daily_cases_thresholds, :bigint, null: false, default: 0
  end
end
