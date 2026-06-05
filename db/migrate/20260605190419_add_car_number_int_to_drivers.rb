class AddCarNumberIntToDrivers < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      ALTER TABLE drivers
      ADD COLUMN car_number_int INTEGER GENERATED ALWAYS AS (CAST(car_number AS INTEGER)) STORED
    SQL
  end

  def down
    remove_column :drivers, :car_number_int
  end
end
