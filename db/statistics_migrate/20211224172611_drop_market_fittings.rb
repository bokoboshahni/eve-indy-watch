class DropMarketFittings < ActiveRecord::Migration[6.1]
  def change
    drop_table :market_fittings
  end
end
