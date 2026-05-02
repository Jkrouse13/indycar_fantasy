class AddPositionToQualifyingPicks < ActiveRecord::Migration[8.1]
  def change
    add_column :fast_twelve_picks, :position, :integer
    add_column :last_row_picks, :position, :integer
    add_column :result_fast_twelves, :position, :integer
    add_column :result_last_rows, :position, :integer
  end
end
