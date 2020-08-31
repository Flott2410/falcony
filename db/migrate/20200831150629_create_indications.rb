class CreateIndications < ActiveRecord::Migration[6.0]
  def change
    create_table :indications do |t|
      t.references :country, null: false, foreign_key: true
      t.text :open
      t.text :quarantine
      t.text :test
      t.string :group_size_public
      t.string :masks_in_public
      t.string :tourism_accomodations
      t.string :restaurants
      t.string :bars_cafes
      t.string :beaches
      t.string :museums
      t.string :personal_services
      t.string :places_of_worship
      t.string :physical_distancing
      t.string :health_protocols
      t.string :public_transportation
      t.string :gatherings
      t.string :high_risk_areas

      t.timestamps
    end
  end
end
