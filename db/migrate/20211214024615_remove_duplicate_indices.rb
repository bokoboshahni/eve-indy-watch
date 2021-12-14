class RemoveDuplicateIndices < ActiveRecord::Migration[6.1]
  def change
    remove_index :contract_fittings, name: "index_contract_fittings_on_contract_id", column: :contract_id
    remove_index :industry_index_snapshots, name: "index_industry_index_snapshots_on_solar_system_id", column: :solar_system_id
    remove_index :market_fitting_snapshots, name: "index_market_fitting_snapshots_on_market_id", column: :market_id
    remove_index :market_price_snapshots, name: "index_market_price_snapshots_on_type_id", column: :type_id
    remove_index :market_type_stats, name: "index_market_type_stats_on_market_id", column: :market_id
  end
end
