class CreateLastRowPicks < ActiveRecord::Migration[8.1]
  def change
    create_table :last_row_picks do |t|
      t.references :qualifying_prediction, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.timestamps
    end
    add_index :last_row_picks, [:qualifying_prediction_id, :driver_id], unique: true
  end
end
