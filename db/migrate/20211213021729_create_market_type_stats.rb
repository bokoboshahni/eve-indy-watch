class CreateMarketTypeStats < ActiveRecord::Migration[6.1]
  def up
    enable_extension 'timescaledb'

    create_table :market_type_stats, id: false do |t|
      t.references :market, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true

      t.bigint :buy_order_count
      t.decimal :buy_price_avg
      t.decimal :buy_price_max
      t.decimal :buy_price_min
      t.decimal :buy_price_sum
      t.decimal :buy_volume_avg
      t.bigint :buy_volume_max
      t.bigint :buy_volume_min
      t.bigint :buy_volume_sum
      t.bigint :sell_order_count
      t.decimal :sell_price_avg
      t.decimal :sell_price_max
      t.decimal :sell_price_min
      t.decimal :sell_price_sum
      t.decimal :sell_volume_avg
      t.bigint :sell_volume_max
      t.bigint :sell_volume_min
      t.bigint :sell_volume_sum
      t.datetime :time, null: false

      t.index %i[market_id type_id time], unique: true, name: :index_unique_market_type_stats
    end

    execute "SELECT create_hypertable('market_type_stats', 'time');"
  end

  def down
    drop_table :market_type_stats

    disable_extension 'timescaledb'
  end
end
