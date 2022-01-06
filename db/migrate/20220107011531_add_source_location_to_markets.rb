class AddSourceLocationToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_reference :markets, :source_location, index: true

    remove_reference :market_locations, :source_location
  end
end
