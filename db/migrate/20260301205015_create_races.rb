class CreateRaces < ActiveRecord::Migration[8.1]
  def change
    create_table :races do |t|
      t.string :name
      t.string :track
      t.datetime :date
      t.datetime :green_flag_time
      t.integer :status
      t.integer :season_year

      t.timestamps
    end
  end
end
