class DropMarketOrderTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :market_order_batch_pages
    drop_table :market_order_batches
    drop_table :market_orders
  end
end
