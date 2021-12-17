class AddBatchPageIDToMarketOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :market_orders, :batch_page_id, :bigint, array: true
  end
end
