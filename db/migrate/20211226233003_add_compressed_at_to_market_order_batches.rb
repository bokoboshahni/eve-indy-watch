class AddCompressedAtToMarketOrderBatches < ActiveRecord::Migration[6.1]
  def change
    add_column :market_order_batches, :compressed_at, :datetime
  end
end
