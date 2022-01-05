class AddSourceLocationToMarketLocations < ActiveRecord::Migration[6.1]
  def change
    add_reference :market_locations, :source_location, index: false
  end
end
