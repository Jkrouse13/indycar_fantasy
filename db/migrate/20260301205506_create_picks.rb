class CreatePicks < ActiveRecord::Migration[8.1]
  def change
    create_table :picks do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true
      t.references :race_tier, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
