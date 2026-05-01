class AddActiveToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :active, :boolean, default: true, null: false
  end
end
