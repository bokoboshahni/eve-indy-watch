class MarketOrderSnapshot < ApplicationRecord
  class CreateStats < ApplicationService
    def initialize(market, time)
      super

      @market = market
      @time = time
    end

    def call
      location_ids = market.market_locations.pluck(:location_id)
      snapshots = MarketOrderSnapshot.group(:kind, :type_id)
                                     .where(location_id: location_ids, esi_last_modified_at: time)

      order_count = snapshots.count
      price_avg = snapshots.average(:price)
      price_max = snapshots.maximum(:price)
      price_min = snapshots.minimum(:price)
      price_sum = snapshots.sum(:price)
      volume_avg = snapshots.average(:volume_remain)
      volume_max = snapshots.maximum(:volume_remain)
      volume_min = snapshots.minimum(:volume_remain)
      volume_sum = snapshots.sum(:volume_remain)

      stats = order_count.keys.map { |k| k.last }.uniq.map do |type_id, a|
        {
          market_id: market_id,
          type_id: type_id,
          time: time,
          buy_order_count: order_count[['buy', type_id]],
          buy_price_avg: price_avg[['buy', type_id]],
          buy_price_max: price_max[['buy', type_id]],
          buy_price_min: price_min[['buy', type_id]],
          buy_price_sum: price_sum[['buy', type_id]],
          buy_volume_avg: volume_avg[['buy', type_id]],
          buy_volume_max: volume_max[['buy', type_id]],
          buy_volume_min: volume_min[['buy', type_id]],
          buy_volume_sum: volume_sum[['buy', type_id]],
          sell_order_count: order_count[['sell', type_id]],
          sell_price_avg: price_avg[['sell', type_id]],
          sell_price_max: price_max[['sell', type_id]],
          sell_price_min: price_min[['sell', type_id]],
          sell_price_sum: price_sum[['sell', type_id]],
          sell_volume_avg: volume_avg[['sell', type_id]],
          sell_volume_max: volume_max[['sell', type_id]],
          sell_volume_min: volume_min[['sell', type_id]],
          sell_volume_sum: volume_sum[['sell', type_id]],
        }
      end

      MarketTypeStat.import(
        stats,
        validate: false,
        on_duplicate_key_update: { conflict_target: %i[market_id type_id time], columns: :all }
      )
    end

    private

    attr_reader :market, :time

    delegate :id, to: :market, prefix: true
  end
end
