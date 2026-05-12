class CreatePoolEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :pool_entries do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :driver,      null: false, foreign_key: true
      t.integer    :value,            null: false
      t.integer    :acquisition_type, null: false
      t.integer    :year,             null: false
      t.timestamps
    end

    add_index :pool_entries, [:participant_id, :driver_id, :year], unique: true
  end
end
