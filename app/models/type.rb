# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`description`**      | `text`             |
# **`name`**             | `text`             | `not null`
# **`packaged_volume`**  | `decimal(, )`      |
# **`portion_size`**     | `integer`          |
# **`published`**        | `boolean`          |
# **`volume`**           | `decimal(, )`      |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`group_id`**         | `bigint`           | `not null`
# **`market_group_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_types_on_group_id`:
#     * **`group_id`**
# * `index_types_on_market_group_id`:
#     * **`market_group_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`group_id => groups.id`**
# * `fk_rails_...`:
#     * **`market_group_id => market_groups.id`**
#
class Type < ApplicationRecord
  belongs_to :group, inverse_of: :types
  belongs_to :market_group, inverse_of: :types, optional: true

  has_one :category, through: :group
  has_one :latest_market_price_snapshot, -> { order esi_last_modified_at: :desc }, class_name: 'MarketPriceSnapshot', foreign_key: :type_id

  has_many :contract_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fitting_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fittings, inverse_of: :type, dependent: :restrict_with_exception
  has_many :market_price_snapshots, inverse_of: :type, dependent: :destroy
  has_many :stations, inverse_of: :type, dependent: :restrict_with_exception
  has_many :structures, inverse_of: :type, dependent: :restrict_with_exception

  delegate :name, to: :category, prefix: true

  delegate :adjusted_price, :average_price, to: :latest_market_price_snapshot

  def charge?
    category_name == Category::CHARGE_CATEGORY_NAME
  end

  def drone?
    category_name == Category::DRONE_CATEGORY_NAME
  end

  def fighter?
    category_name == Category::FIGHTER_CATEGORY_NAME
  end

  def module?
    Category::MODULE_CATEGORY_NAMES.include?(category_name)
  end

  def market_price(market_id, interval: '5m', kind:)
    Rollup.where(name: "mkt_#{market_id}_types.price_min", interval: interval)
          .where("dimensions->>'kind' = ? AND (dimensions->'type_id')::bigint = ?", kind, id)
          .order(time: :desc).limit(1)&.first&.value || BigDecimal(0)
  end

  def market_buy_price(market_id, interval: '5m')
    market_price(market_id, interval: interval, kind: 'buy')
  end

  def market_sell_price(market_id, interval: '5m')
    market_price(market_id, interval: interval, kind: 'sell')
  end

  def market_volume(market_id, interval: '5m')
    Rollup.where(name: "mkt_#{market_id}_types.volume_sum", interval: interval)
          .where("dimensions->>'kind' = 'sell' AND (dimensions->'type_id')::bigint = ?", id)
          .order(time: :desc).limit(1)&.first&.value&.to_i || 0
  end
end
