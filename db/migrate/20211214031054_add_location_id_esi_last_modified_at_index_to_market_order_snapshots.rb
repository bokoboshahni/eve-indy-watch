class AddLocationIDESILastModifiedAtIndexToMarketOrderSnapshots < ActiveRecord::Migration[6.1]
  def change
    remove_index :market_order_snapshots, name: :index_unique_market_order_snapshots

    commit_db_transaction
    add_index :market_order_snapshots, %i[location_id esi_last_modified_at], name: :index_market_order_snapshots_on_location_id_and_time, algorithm: :concurrently
  end
end
