class CreateQualifyingResults < ActiveRecord::Migration[8.1]
  def change
    create_table :qualifying_results do |t|
      t.integer :year, null: false
      t.references :pole_driver, foreign_key: { to_table: :drivers }, null: true
      t.boolean :saturday_wreck, default: false, null: false
      t.boolean :sunday_wreck, default: false, null: false
      t.boolean :finalized, default: false, null: false
      t.timestamps
    end
    add_index :qualifying_results, :year, unique: true
  end
end
