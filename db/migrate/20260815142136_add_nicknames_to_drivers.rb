class AddNicknamesToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :nicknames, :string
  end
end
