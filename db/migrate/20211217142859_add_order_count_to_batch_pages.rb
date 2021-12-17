class AddOrderCountToBatchPages < ActiveRecord::Migration[6.1]
  def change
    add_column :market_order_batch_pages, :order_count, :integer
  end
end
