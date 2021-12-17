class AddStartedAtToBatchPages < ActiveRecord::Migration[6.1]
  def change
    add_column :market_order_batch_pages, :started_at, :datetime
  end
end
