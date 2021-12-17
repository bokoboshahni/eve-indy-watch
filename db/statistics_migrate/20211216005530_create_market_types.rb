class CreateMarketTypes < ActiveRecord::Migration[6.1]
  def up
    create_table :market_types, id: false do |t|
      t.bigint :market_id, null: false
      t.bigint :type_id, null: false
      t.timestamp :time, null: false

      t.decimal :buy_five_pct_price_avg
      t.decimal :buy_five_pct_price_med
      t.bigint :buy_five_pct_order_count
      t.decimal :buy_price_avg
      t.decimal :buy_price_min
      t.decimal :buy_price_med
      t.decimal :buy_price_max
      t.decimal :buy_price_sum
      t.decimal :buy_volume_avg
      t.bigint :buy_volume_min
      t.bigint :buy_volume_med
      t.bigint :buy_volume_max
      t.bigint :buy_volume_sum
      t.bigint :buy_total_order_count
      t.bigint :buy_trimmed_order_count

      t.decimal :sell_five_pct_price_avg
      t.decimal :sell_five_pct_price_med
      t.decimal :sell_five_pct_order_count
      t.decimal :sell_price_avg
      t.decimal :sell_price_min
      t.decimal :sell_price_med
      t.decimal :sell_price_max
      t.decimal :sell_price_sum
      t.decimal :sell_volume_avg
      t.bigint :sell_volume_min
      t.bigint :sell_volume_med
      t.bigint :sell_volume_max
      t.bigint :sell_volume_sum
      t.bigint :sell_total_order_count
      t.bigint :sell_trimmed_order_count

      t.decimal :buy_sell_price_spread
    end

    execute "SELECT create_hypertable('market_types', 'time');"

    execute "SELECT add_retention_policy('market_types', interval '1 week');"
  end

  def down
    drop_table :market_types
  end
end
