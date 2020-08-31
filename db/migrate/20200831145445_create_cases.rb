class CreateCases < ActiveRecord::Migration[6.0]
  def change
    create_table :cases do |t|
      t.integer :total_cases
      t.integer :new_cases
      t.integer :total_deaths
      t.integer :new_deaths
      t.integer :population
      t.integer :total_tests
      t.integer :new_tests
      t.integer :tests_per_case
      t.integer :stringency_index

      t.timestamps
    end
  end
end
