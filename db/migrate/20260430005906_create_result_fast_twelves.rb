class CreateResultFastTwelves < ActiveRecord::Migration[8.1]
  def change
    create_table :result_fast_twelves do |t|
      t.references :qualifying_result, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.timestamps
    end
    add_index :result_fast_twelves, [:qualifying_result_id, :driver_id], unique: true
  end
end
