# frozen_string_literal: true

# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`owner_type`**  | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`owner_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_markets_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
#
class Market < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true

  has_many :alliances_as_appraisal_market, class_name: 'Alliance', inverse_of: :appraisal_market
  has_many :alliances_as_main_market, class_name: 'Alliance', inverse_of: :main_market
  has_many :market_fitting_snapshots, inverse_of: :market, dependent: :destroy
  has_many :market_locations, inverse_of: :market, dependent: :destroy
  has_many :stations, through: :market_locations, source: :location, source_type: 'Station'
  has_many :structures, through: :market_locations, source: :location, source_type: 'Structure'

  validates :name, presence: true

  def type_ids_for_sale
    time = MarketTypeStat.where(market_id: id).maximum(:time)
    MarketTypeStat.distinct(:type_id).where(market_id: id).pluck(:type_id)
  end

  def create_stats!(time)
    MarketOrderSnapshot::CreateStats.call(self, time)
  end

  def create_stats_async(time)
    MarketOrderSnapshot::CreateStatsWorker.perform_async(id, time)
  end
end
