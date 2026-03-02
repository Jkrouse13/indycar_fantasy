class AddColorsToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :primary_color, :string
    add_column :drivers, :secondary_color, :string
  end
end
