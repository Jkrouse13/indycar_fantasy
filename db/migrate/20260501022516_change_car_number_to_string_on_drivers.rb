class ChangeCarNumberToStringOnDrivers < ActiveRecord::Migration[8.1]
  def change
    change_column :drivers, :car_number, :string
  end
end
