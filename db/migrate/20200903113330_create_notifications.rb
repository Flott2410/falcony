class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
