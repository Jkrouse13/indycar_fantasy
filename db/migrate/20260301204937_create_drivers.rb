class CreateDrivers < ActiveRecord::Migration[8.1]
  def change
    create_table :drivers do |t|
      t.string :name
      t.integer :car_number
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
