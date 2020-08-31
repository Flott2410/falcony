class CreateIndications < ActiveRecord::Migration[6.0]
  def change
    create_table :indications do |t|
      t.references :country, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :status
      t.string :category

      t.timestamps
    end
  end
end
