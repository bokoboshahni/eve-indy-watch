class AddOrdersUpdatedAtToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :orders_updated_at, :datetime
    add_column :regions, :orders_updated_at, :datetime
    add_column :structures, :orders_updated_at, :datetime
  end
end
