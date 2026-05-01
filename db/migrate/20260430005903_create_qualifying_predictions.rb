class CreateQualifyingPredictions < ActiveRecord::Migration[8.1]
  def change
    create_table :qualifying_predictions do |t|
      t.references :participant, null: false, foreign_key: true
      t.integer :year, null: false
      t.references :pole_pick_driver, foreign_key: { to_table: :drivers }, null: true
      t.boolean :saturday_wreck, default: false, null: false
      t.boolean :sunday_wreck, default: false, null: false
      t.timestamps
    end
    add_index :qualifying_predictions, [:participant_id, :year], unique: true
  end
end
