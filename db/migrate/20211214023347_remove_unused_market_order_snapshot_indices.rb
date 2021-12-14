class RemoveUnusedMarketOrderSnapshotIndices < ActiveRecord::Migration[6.1]
  def change
    remove_index :market_order_snapshots, name: "index_market_order_snapshots_on_location"
    remove_index :market_order_snapshots, name: "index_market_order_snapshots_on_solar_system_id"
    remove_index :market_order_snapshots, name: "index_market_order_snapshots_on_type_id"
  end
end
