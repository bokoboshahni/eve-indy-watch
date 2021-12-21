class Market < ApplicationRecord
  class AggregateTypeStats < ApplicationService
    def initialize(market, time, batch)
      super

      @batch = batch
      @market = market
      @time = time
    end

    def call
      if batch.location.is_a?(Region) && market.private?
        error "Cannot aggregate type statistics from regional batch #{batch.id} for private market #{market.log_name}"
        return
      end

      if Statistics::MarketType.exists?(market_id: market_id, time: time)
        warn "Aggregated type statistics already exist for #{market_name} at #{time}"
        return
      end

      location_ids = market.market_locations.pluck(:location_id)

      region_ids = market.regions.pluck(:id)

      region_join =
        if region_ids.any?
          <<~SQL
            INNER JOIN solar_systems ON solar_systems.id = market_orders.solar_system_id
            INNER JOIN constellations ON constellations.id = solar_systems.constellation_id
            INNER JOIN regions ON regions.id = constellations.region_id
          SQL
        else
          ''
        end

      location_query =
        if region_ids.any?
          "(location_id IN (#{location_ids.join(',')}) OR regions.id IN (#{region_ids.join(',')}))"
        else
          "location_id IN (#{location_ids.join(',')})"
        end

      query = <<~SQL
        WITH all_orders AS (
            SELECT kind,
                  type_id,
                  order_id,
                  price,
                  volume_remain                                       as volume,
                  (max(price) over (partition by kind, type_id))      as max_price,
                  (min(price) over (partition by kind, type_id))      as min_price,
                  (count(order_id) over (partition by kind, type_id)) as total_order_count
            FROM market_orders
            #{region_join}
            WHERE time = '#{time.to_s(:db)}'
              AND #{location_query}
        ),
            ranked_orders AS (
                SELECT kind,
                        type_id,
                        price,
                        volume,
                        percent_rank() over (partition by kind, type_id order by volume)        as rank,
                        count(order_id) over (partition by kind, type_id)                       as order_count,
                        (total_order_count - count(order_id) over (partition by kind, type_id)) as trimmed_count,
                        total_order_count                                                       as original_order_count
                FROM all_orders
                WHERE (kind = 'buy' AND price >= (max_price * 0.1))
                    OR (kind = 'sell' AND price <= min_price * 10)
            )

        SELECT kind,
              type_id,
              round(avg(price) FILTER (WHERE (kind = 'buy' AND rank >= 0.95) OR (kind = 'sell' AND rank <= 0.05)),
                    2)                                                                                    as five_pct_price_avg,
              percentile_cont(0.5) WITHIN GROUP (ORDER BY price) FILTER (WHERE (kind = 'buy' AND rank >= 0.95) OR (kind = 'sell' AND rank <= 0.05))
                                                                                                          as five_pct_price_med,
              count(*)
              FILTER (WHERE (kind = 'buy' AND rank >= 0.95) OR (kind = 'sell' AND rank <= 0.05))          as five_pct_order_count,
              round(avg(price))                                                                           as price_avg,
              min(price)                                                                                  as price_min,
              percentile_cont(0.5) WITHIN GROUP (ORDER BY price)                                          as price_med,
              max(price)                                                                                  as price_max,
              sum(price)                                                                                  as price_sum,
              round(avg(volume), 2)                                                                       as volume_avg,
              min(volume)                                                                                 as volume_min,
              percentile_cont(0.5) WITHIN GROUP (ORDER BY volume)                                         as volume_med,
              max(volume)                                                                                 as volume_max,
              sum(volume)                                                                                 as volume_sum,
              avg(original_order_count)                                                                   as total_order_count,
              avg(trimmed_count)                                                                          as trimmed_order_count
        FROM ranked_orders
        GROUP BY kind, type_id;
      SQL

      results = ActiveRecord::Base.connection.exec_query(query).to_a
      record_template = { market_id: market_id, time: time }
      records = results.each_with_object({}) do |row, h|
        kind = row.delete('kind')
        key = row.delete('type_id')
        h[key] ||= record_template.merge(type_id: key)
        h[key].merge!(row.transform_keys! { |k| "#{kind}_#{k}".to_sym })
      end

      columns = Statistics::MarketType.column_names.map(&:to_sym).excluding(:kind, :type_id)
      columns += %i[
        buy_sell_price_spread
        sell_trimmed_order_count sell_total_order_count
        buy_total_order_count buy_trimmed_order_count
      ]
      records = records.values.map! do |record|
        record[:buy_sell_price_spread] = record[:sell_price_min].to_d - record[:buy_price_max].to_d
        (columns - record.keys).each { |c| record[c] = nil }
        record
      end

      market.transaction do
        Statistics::MarketType.import(records, validate: false)
        market.update!(type_stats_updated_at: time)
      end

      debug "Aggregated market type statistics for #{records.count} type(s) in #{market_name}"
    end

    private

    TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'

    attr_reader :market, :time, :batch

    delegate :id, :name, to: :market, prefix: true
  end
end
