# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`description`**           | `text`             |
# **`max_production_limit`**  | `integer`          |
# **`name`**                  | `text`             | `not null`
# **`packaged_volume`**       | `decimal(, )`      |
# **`portion_size`**          | `integer`          |
# **`published`**             | `boolean`          |
# **`volume`**                | `decimal(, )`      |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`group_id`**              | `bigint`           | `not null`
# **`market_group_id`**       | `bigint`           |
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
  include PgSearch::Model

  multisearchable against: %i[description name market_group_name category_name group_name]

  belongs_to :group, inverse_of: :types
  belongs_to :market_group, inverse_of: :types, optional: true

  has_one :blueprint_product, class_name: 'BlueprintProduct', inverse_of: :product_type, foreign_key: :product_type_id
  has_one :blueprint, class_name: 'Type', through: :blueprint_product, source: :blueprint_type
  has_one :category, through: :group
  has_one :latest_market_price_snapshot, lambda {
                                           order esi_last_modified_at: :desc
                                         }, class_name: 'MarketPriceSnapshot', foreign_key: :type_id

  has_many :appraisal_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :blueprint_activities, foreign_key: :blueprint_type_id
  has_many :blueprint_materials, inverse_of: :blueprint_type, foreign_key: :blueprint_type_id
  has_many :blueprint_products, inverse_of: :blueprint_type, foreign_key: :blueprint_type_id
  has_many :blueprint_required_materials, class_name: 'BlueprintMaterial', inverse_of: :material_type, foreign_key: :material_type_id
  has_many :blueprint_required_skills, class_name: 'BlueprintSkill', inverse_of: :skill_type, foreign_key: :skill_type_id
  has_many :blueprint_skills, inverse_of: :blueprint_type, foreign_key: :blueprint_type_id
  has_many :contract_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fitting_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fittings, inverse_of: :type, dependent: :restrict_with_exception
  has_many :killmail_attacker_ships, inverse_of: :ship_type, dependent: :restrict_with_exception
  has_many :killmail_attacker_weapons, inverse_of: :weapon_type, dependent: :restrict_with_exception
  has_many :killmail_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :lossmails, class_name: 'Killmail', inverse_of: :ship_type, dependent: :restrict_with_exception
  has_many :market_price_snapshots, inverse_of: :type, dependent: :destroy
  has_many :market_stats, class_name: 'Statistics::MarketType', inverse_of: :market
  has_many :stations, inverse_of: :type, dependent: :restrict_with_exception
  has_many :structures, inverse_of: :type, dependent: :restrict_with_exception

  accepts_nested_attributes_for :blueprint_activities

  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true
  delegate :name, to: :market_group, prefix: true, allow_nil: true

  scope :marketable, -> { where.not(market_group_id: nil) }
  scope :published, -> { where(published: true) }

  def blueprint?
    category_name == Category::BLUEPRINT_CATEGORY_NAME
  end

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

  def market_stat(market, stat)
    @market_stat ||= {}
    @market_stat["#{market.id}_#{stat}"] ||=
      begin
        Statistics::MarketType.find_by(
          market_id: market.id,
          type_id: id,
          time: Statistics::MarketType.where(market_id: market.id, type_id: id).maximum(:time)
        )&.send(stat) || 0
      end
  end

  Statistics::MarketType.column_names.excluding('market_id', 'type_id', 'time').each do |stat|
    define_method "market_#{stat}" do |market|
      market_stat(market, stat)
    end
  end

  def market_buy_price(market)
    market_stat(market, :buy_price_max)
  end

  def market_sell_price(market)
    market_stat(market, :sell_price_min)
  end

  def market_split_price(market)
    (market_buy_price(market) + market_sell_price(market)) / 2.0
  end

  def market_volume(market)
    market_stat(market, :sell_volume_sum)
  end

  def icon_url
    "https://images.evetech.net/types/#{id}/icon"
  end

  def render_url
    "https://images.evetech.net/types/#{id}/render"
  end

  def lead_time
    blueprint.blueprint_activities.find_by(activity: 'manufacturing').time
  end

  def lead_time_days
    (lead_time / 60 / 60 / 24.0).to_d
  end

  def regional_history(region, period)
    Statistics::RegionTypeHistory.where(region_id: region.id, type_id: id, date: build_period(period))
  end

  def regional_sales_daily_avg(region, period = nil)
    range = build_period(period)
    days = (range.first.to_date...range.last.to_date).count
    regional_history(region, period).average(:volume)
  end

  def build_period(period = nil)
    return default_period unless period

    case period
    when :week
      7.days.ago.beginning_of_day..Time.zone.now
    when :month
      30.days.ago.beginning_of_day..Time.zone.now
    else
      period
    end
  end

  def default_period
    30.days.ago.beginning_of_day..Time.zone.now
  end
end
