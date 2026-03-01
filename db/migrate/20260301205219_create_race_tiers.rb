class CreateRaceTiers < ActiveRecord::Migration[8.1]
  def change
    create_table :race_tiers do |t|
      t.references :race, null: false, foreign_key: true
      t.integer :tier_number

      t.timestamps
    end
  end
end
