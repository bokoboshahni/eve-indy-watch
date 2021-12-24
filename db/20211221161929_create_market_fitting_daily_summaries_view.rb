class CreateMarketFittingDailySummariesView < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    execute <<-SQL
      CREATE MATERIALIZED VIEW market_fittings_daily
      WITH (
        timescaledb.continuous
      ) AS
      SELECT
        time_bucket('1d', time) AS bucket,
        fitting_id,
        market_id,

        AVG(price_buy) AS price_buy_avg,
        MIN(price_buy) AS price_buy_min,
        MIN(price_buy) AS price_buy_max,

        AVG(price_sell) AS price_sell_avg,
        MIN(price_sell) AS price_sell_min,
        MIN(price_sell) AS price_sell_max,

        AVG(price_split) AS price_split_avg,
        MIN(price_split) AS price_split_min,
        MIN(price_split) AS price_split_max,

        AVG(quantity) AS quantity_avg,
        MIN(quantity) AS quantity_min,
        MIN(quantity) AS quantity_max,
        SUM(quantity) AS quantity_sum
      FROM market_fittings
      GROUP BY bucket, market_id, fitting_id;
    SQL

    execute <<~SQL
      SELECT add_continuous_aggregate_policy(
        'market_fittings_daily',
        start_offset => INTERVAL '1 day',
        end_offset => INTERVAL '1 hour',
        schedule_interval => INTERVAL '1 hour'
      );
    SQL
  end

  def down
    execute <<-SQL
      DROP market_fittings_daily CASCADE
    SQL
  end
end
