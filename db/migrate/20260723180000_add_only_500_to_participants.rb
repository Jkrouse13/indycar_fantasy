class AddOnly500ToParticipants < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :only_500, :boolean, default: false, null: false
  end
end
