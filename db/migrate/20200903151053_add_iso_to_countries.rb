class AddIsoToCountries < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :iso, :string
  end
end
