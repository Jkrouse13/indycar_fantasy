class AddWreckCancelledToQualifyingResults < ActiveRecord::Migration[8.1]
  def change
    add_column :qualifying_results, :saturday_wreck_cancelled, :boolean, default: false, null: false
    add_column :qualifying_results, :sunday_wreck_cancelled, :boolean, default: false, null: false
  end
end
