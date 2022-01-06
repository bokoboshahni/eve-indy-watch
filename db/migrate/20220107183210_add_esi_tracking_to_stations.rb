class AddESITrackingToStations < ActiveRecord::Migration[6.1]
  def change
    add_column :stations, :esi_expires_at, :datetime
    add_column :stations, :esi_last_modified_at, :datetime
  end
end
