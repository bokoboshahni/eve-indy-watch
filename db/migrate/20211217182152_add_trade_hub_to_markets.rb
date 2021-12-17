class AddTradeHubToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :trade_hub, :boolean
  end
end
