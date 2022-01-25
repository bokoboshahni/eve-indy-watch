# frozen_string_literal: true

# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`active`**                  | `boolean`          |
# **`archiving_enabled`**       | `boolean`          |
# **`name`**                    | `text`             | `not null`
# **`orders_updated_at`**       | `datetime`         |
# **`owner_type`**              | `string`           |
# **`private`**                 | `boolean`          |
# **`regional`**                | `boolean`          |
# **`trade_hub`**               | `boolean`          |
# **`type_stats_updated_at`**   | `datetime`         |
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`owner_id`**                | `bigint`           |
# **`source_location_id`**      | `bigint`           |
# **`type_history_region_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_markets_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_markets_on_source_location_id`:
#     * **`source_location_id`**
# * `index_markets_on_type_history_region_id`:
#     * **`type_history_region_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_history_region_id => regions.id`**
#
class Market < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name owner_name]

  pg_search_scope :search_by_all, against: %i[name],
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :source_location, class_name: 'Location', inverse_of: :markets, optional: true
  belongs_to :type_history_region, class_name: 'Region', inverse_of: :markets_for_type_history, optional: true

  has_many :alliances_as_appraisal_market, class_name: 'Alliance', inverse_of: :appraisal_market
  has_many :alliances_as_main_market, class_name: 'Alliance', inverse_of: :main_market
  has_many :appraisals, inverse_of: :market, dependent: :destroy
  has_many :fitting_markets, inverse_of: :market
  has_many :fitting_stock_levels, inverse_of: :market
  has_many :fittings, through: :fitting_markets
  has_many :market_locations, inverse_of: :market, dependent: :destroy
  has_many :orders, class_name: 'MarketOrder', through: :market_locations
  has_many :order_prices, class_name: 'MarketOrderPrice', inverse_of: :market
  has_many :regions, through: :market_locations, source: :location, source_type: 'Region'
  has_many :snapshot_locations, class_name: 'Location', through: :market_locations
  has_many :stations, through: :market_locations, source: :location, source_type: 'Station'
  has_many :structures, through: :market_locations, source: :location, source_type: 'Structure'

  has_many :type_stats, class_name: 'MarketTypeStats', inverse_of: :market

  scope :active, -> { where(active: true) }

  delegate :name, to: :owner, prefix: true, allow_nil: true

  validates :name, presence: true

  def kind
    return owner.class.name.underscore if owner

    return 'trade_hub' if trade_hub?

    return 'regional' if regional?
  end

  def latest_orders
    if regional?
      scope = MarketOrder.joins(solar_system: { constellation: :region }).where(regions: { id: regions.pluck(:id) })
      time = scope.maximum(:time)
      scope.where(time: time)
    else
      orders.where(time: orders.maximum(:time))
    end
  end

  def location_ids
    market_locations.pluck(:location_id)
  end

  def types
    Type.where(id: type_ids_for_sale)
  end

  def type_ids_for_sale
    markets_reader.smembers("#{latest_snapshot_key}.types.type_ids")
  end

  def aggregate_type_stats!(time, batch)
    AggregateTypeStats.call(self, time, batch)
  end

  def aggregate_type_stats_async(time, _batch)
    AggregateTypeStatsWorker.perform_async(id, time, batch_id)
  end

  def latest_snapshot_time
    markets_reader.get("markets.#{id}.latest")&.to_datetime
  end

  def latest_snapshot_key
    "markets.#{id}.#{latest_snapshot_time.to_s(:number)}"
  end

  def latest_snapshot_type_ids
    markets_reader.smembers("#{latest_snapshot_key}.types.type_ids")
  end

  def snapshot_keys
    return [] unless markets_reader.exists("markets.#{id}.snapshots") == 1

    markets_reader.zrangebyscore("markets.#{id}.snapshots", 0, latest_snapshot_time.to_s(:number).to_i,
                                 with_scores: true)
                  .to_h.invert.transform_keys(&:to_i)
  end

  def calculate_type_statistics_async(time, force: false)
    CalculateTypeStatisticsQueuer.call(self, time, force: force)
  end

  def orders_last_modified
    source_location.locatable.orders_last_modified
  end

  def latest_order_count
    markets_reader.get("#{latest_snapshot_key}.order_count").to_i
  end

  def latest_type_count
    markets_reader.get("#{latest_snapshot_key}.type_count").to_i
  end

  def update_ingestion_info!
    markets_writer.set("markets.#{id}.kind", kind)
    markets_writer.set("markets.#{id}.name", name)
    markets_writer.set("markets.#{id}.source_location_id", source_location_id)
    markets_writer.sadd("markets.#{id}.location_ids", location_ids) if location_ids.any?
  end
end
