class AddCountriesToCases < ActiveRecord::Migration[6.0]
  def change
    add_reference :cases, :country, null: false, foreign_key: true
  end
end
