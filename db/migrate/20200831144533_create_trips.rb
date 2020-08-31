class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.references :origin, null: false, foreign_key: { to_table: :countries }
      t.references :destination, null: false, foreign_key: { to_table: :countries }
      t.references :user, null: false, foreign_key: true
      t.boolean :bookmarked

      t.timestamps
    end
  end
end
