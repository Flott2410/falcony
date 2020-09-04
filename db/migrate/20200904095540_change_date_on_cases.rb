class ChangeDateOnCases < ActiveRecord::Migration[6.0]
  def change
    change_column :cases, :date, :date, default: Date.parse("2020-09-01"), null: false
  end
end
