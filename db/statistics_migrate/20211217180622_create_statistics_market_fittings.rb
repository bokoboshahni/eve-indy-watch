class CreateStatisticsMarketFittings < ActiveRecord::Migration[6.1]
  def up
    create_table :market_fittings, id: false, primary_key: %i[fitting_id market_id time] do |t|
      t.bigint :fitting_id, null: false
      t.bigint :market_id, null: false
      t.timestamp :time, null: false

      t.jsonb :items, nil: false, default: {}
      t.decimal :price_buy
      t.decimal :price_sell
      t.decimal :price_split
      t.integer :quantity
    end

    execute "SELECT create_hypertable('market_fittings', 'time');"

    execute "SELECT add_retention_policy('market_fittings', interval '1 week');"
  end

  def down
    drop_table :market_fittings
  end
end
