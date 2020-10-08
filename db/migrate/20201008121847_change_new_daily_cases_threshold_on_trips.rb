class ChangeNewDailyCasesThresholdOnTrips < ActiveRecord::Migration[6.0]
  def change
    rename_column :trips, :new_daily_cases_thresholds, :new_daily_cases_threshold
  end
end
