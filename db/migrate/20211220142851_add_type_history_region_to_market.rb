class AddTypeHistoryRegionToMarket < ActiveRecord::Migration[6.1]
  def change
    add_reference :markets, :type_history_region, foreign_key: { to_table: :regions }
  end
end
