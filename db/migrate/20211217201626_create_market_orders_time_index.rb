class CreateMarketOrdersTimeIndex < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :market_orders, :time, algorithm: :concurrently
  end
end
