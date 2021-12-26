class RemoveNullConstraintFromMarketOrderBatchPages < ActiveRecord::Migration[6.1]
  def change
    change_column :market_order_batch_pages, :orders, :text, null: true
  end
end
