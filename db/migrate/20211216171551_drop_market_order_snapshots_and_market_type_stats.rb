class DropMarketOrderSnapshotsAndMarketTypeStats < ActiveRecord::Migration[6.1]
  def change
    drop_table :market_type_stats, force: :cascade
    drop_table :market_order_snapshots, force: :cascade
  end
end
