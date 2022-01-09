class CreateMarketTypeStats < ActiveRecord::Migration[6.1]
  def up
    create_table :market_type_stats, id: :false, primary_key: %i[market_id type_id time] do |t|
      t.bigint :market_id, null: false
      t.bigint :type_id, null: false
      t.timestamp :time, null: false

      t.decimal :buy_five_pct_price_avg
      t.decimal :buy_five_pct_price_max
      t.decimal :buy_five_pct_price_med
      t.decimal :buy_five_pct_price_min
      t.decimal :buy_five_pct_price_sum
      t.integer :buy_five_pct_order_count
      t.decimal :buy_price_avg
      t.decimal :buy_price_max
      t.decimal :buy_price_med
      t.decimal :buy_price_min
      t.decimal :buy_price_sum
      t.integer :buy_outlier_count
      t.decimal :buy_outlier_threshold
      t.integer :buy_order_count
      t.integer :buy_trade_count
      t.decimal :buy_volume_avg
      t.bigint  :buy_volume_max
      t.bigint  :buy_volume_med
      t.bigint  :buy_volume_min
      t.bigint  :buy_volume_sum
      t.decimal :buy_volume_traded_avg
      t.bigint  :buy_volume_traded_max
      t.bigint  :buy_volume_traded_med
      t.bigint  :buy_volume_traded_min
      t.bigint  :buy_volume_traded_sum

      t.decimal :sell_five_pct_price_avg
      t.decimal :sell_five_pct_price_max
      t.decimal :sell_five_pct_price_med
      t.decimal :sell_five_pct_price_min
      t.decimal :sell_five_pct_price_sum
      t.integer :sell_five_pct_order_count
      t.decimal :sell_price_avg
      t.decimal :sell_price_max
      t.decimal :sell_price_med
      t.decimal :sell_price_min
      t.decimal :sell_price_sum
      t.integer :sell_outlier_count
      t.decimal :sell_outlier_threshold
      t.integer :sell_order_count
      t.integer :sell_trade_count
      t.decimal :sell_volume_avg
      t.bigint  :sell_volume_max
      t.bigint  :sell_volume_med
      t.bigint  :sell_volume_min
      t.bigint  :sell_volume_sum
      t.decimal :sell_volume_traded_avg
      t.bigint  :sell_volume_traded_max
      t.bigint  :sell_volume_traded_med
      t.bigint  :sell_volume_traded_min
      t.bigint  :sell_volume_traded_sum

      t.decimal :buy_sell_spread
      t.decimal :mid_price

      t.jsonb :depth
      t.jsonb :flow

      t.index %i[market_id type_id time], unique: true, name: :index_unique_market_type_stats, order: { time: :desc }
    end

    execute "SELECT create_hypertable('market_type_stats', 'time', chunk_time_interval => INTERVAL '1 hour');"

    execute "SELECT add_retention_policy('market_type_stats', INTERVAL '36 hours');"
  end

  def down
    drop_table :market_type_stats
  end
end
