# frozen_string_literal: true

# ## Schema Information
#
# Table name: `regions`
#
# ### Columns
#
# Name                                      | Type               | Attributes
# ----------------------------------------- | ------------------ | ---------------------------
# **`id`**                                  | `bigint`           | `not null, primary key`
# **`esi_market_orders_expires_at`**        | `datetime`         |
# **`esi_market_orders_last_modified_at`**  | `datetime`         |
# **`market_order_sync_enabled`**           | `boolean`          |
# **`name`**                                | `text`             | `not null`
# **`orders_updated_at`**                   | `datetime`         |
# **`created_at`**                          | `datetime`         | `not null`
# **`updated_at`**                          | `datetime`         | `not null`
# **`esi_authorization_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_regions_on_esi_authorization_id`:
#     * **`esi_authorization_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`esi_authorization_id => esi_authorizations.id`**
#
class Region < ApplicationRecord
  include MarketOrdersSyncable
  include PgSearch::Model

  multisearchable against: %i[name]

  belongs_to :esi_authorization, inverse_of: :regions, optional: true

  has_many :constellations, inverse_of: :region, dependent: :restrict_with_exception

  has_many :contracts, through: :solar_systems
  has_many :market_locations, as: :location, dependent: :destroy
  has_many :market_orders, through: :constellations
  has_many :markets, through: :market_locations
  has_many :solar_systems, through: :constellations
  has_many :stations, through: :solar_systems
  has_many :structures, through: :solar_systems

  def available_esi_authorizations
    main_alliance.available_esi_authorizations
  end

  def esi_authorized?
    esi_authorization.present?
  end
end
