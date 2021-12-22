class AddLocationNameToContractsAndMarketOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :start_location_name, :text
    add_column :contracts, :end_location_name, :text

    add_column :market_orders, :location_name, :text
  end
end
