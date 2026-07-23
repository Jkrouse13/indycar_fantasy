class CreateRaceCarLiveries < ActiveRecord::Migration[8.1]
  def change
    create_table :race_car_liveries do |t|
      t.references :race, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.string :image_url
      t.string :primary_color
      t.string :secondary_color

      t.timestamps
    end

    add_index :race_car_liveries, [ :race_id, :driver_id ], unique: true
  end
end
