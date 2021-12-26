class RemoveOrdersFromMarketOrderBatchPages < ActiveRecord::Migration[6.1]
  def change
    remove_column :market_order_batch_pages, :orders, :text
  end
end
