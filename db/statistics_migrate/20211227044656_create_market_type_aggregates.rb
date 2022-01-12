# frozen_string_literal: true

class CreateMarketTypeAggregates < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    execute <<-SQL.squish
      CREATE MATERIALIZED VIEW market_type_daily_summaries
      WITH (
        timescaledb.continuous
      ) AS
      SELECT
        time_bucket('1 day', time) AS bucket,
        market_id,
        type_id,

        AVG(buy_price_max) AS buy_price_avg,
        MIN(buy_price_min) AS buy_price_min,
        MAX(buy_price_max) AS buy_price_max,
        MIN(buy_volume_min) AS buy_volume_min,
        MAX(buy_volume_max) AS buy_volume_max,
        AVG(buy_volume_sum) AS buy_volume_sum_avg,
        AVG(buy_trimmed_order_count) AS buy_order_count_avg,
        MIN(buy_trimmed_order_count) AS buy_order_count_min,
        MAX(buy_trimmed_order_count) AS buy_order_count_max,
        AVG(sell_price_min) AS sell_price_avg,
        MIN(sell_price_min) AS sell_price_min,
        MAX(sell_price_max) AS sell_price_max,
        MIN(sell_volume_min) AS sell_volume_min,
        MAX(sell_volume_max) AS sell_volume_max,
        AVG(sell_volume_sum) AS sell_volume_sum_avg,
        AVG(sell_trimmed_order_count) AS sell_order_count_avg,
        MIN(sell_trimmed_order_count) AS sell_order_count_min,
        MAX(sell_trimmed_order_count) AS sell_order_count_max,
        AVG(buy_sell_price_spread) AS buy_sell_price_spread_avg,
        MIN(buy_sell_price_spread) AS buy_sell_price_spread_min,
        MAX(buy_sell_price_spread) AS buy_sell_price_spread_max
      FROM market_types
      GROUP BY market_id, type_id, time_bucket('1 day', time);
    SQL

    execute <<~SQL.squish
      SELECT add_continuous_aggregate_policy(
        'market_type_daily_summaries',
        start_offset => INTERVAL '3 days',
        end_offset => INTERVAL '1 hour',
        schedule_interval => INTERVAL '1 hour'
      );
    SQL
  end

  def down
    execute 'DROP MATERIALIZED VIEW market_type_daily_summaries CASCADE;'
  end
end
