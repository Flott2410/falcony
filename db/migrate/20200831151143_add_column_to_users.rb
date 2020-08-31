class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :home_country, :string
  end
end
