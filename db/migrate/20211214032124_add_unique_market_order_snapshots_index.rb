class AddUniqueMarketOrderSnapshotsIndex < ActiveRecord::Migration[6.1]
  def change
    commit_db_transaction
    add_index :market_order_snapshots, %i[esi_last_modified_at order_id], unique: true, name: :index_unique_market_order_snapshots, algorithm: :concurrently
  end
end
