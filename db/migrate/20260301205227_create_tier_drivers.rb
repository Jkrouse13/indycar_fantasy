class CreateTierDrivers < ActiveRecord::Migration[8.1]
  def change
    create_table :tier_drivers do |t|
      t.references :race_tier, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
