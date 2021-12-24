class CreateFittingMarkets < ActiveRecord::Migration[6.1]
  def change
    create_table :fitting_markets, id: false, primary_key: %i[fitting_id market_id] do |t|
      t.references :fitting, null: false, index: false, foreign_key: true
      t.references :market, null: false, index: false, foreign_key: true

      t.boolean :contract_stock_level_enabled, null: false
      t.boolean :market_stock_level_enabled, null: false
      t.timestamps null: false
    end
  end
end
