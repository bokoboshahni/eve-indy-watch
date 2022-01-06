# frozen_string_literal: true

# ## Schema Information
#
# Table name: `structures`
#
# ### Columns
#
# Name                                      | Type               | Attributes
# ----------------------------------------- | ------------------ | ---------------------------
# **`id`**                                  | `bigint`           | `not null, primary key`
# **`esi_expires_at`**                      | `datetime`         |
# **`esi_last_modified_at`**                | `datetime`         |
# **`esi_market_orders_expires_at`**        | `datetime`         |
# **`esi_market_orders_last_modified_at`**  | `datetime`         |
# **`market_order_sync_enabled`**           | `boolean`          |
# **`name`**                                | `text`             | `not null`
# **`orders_updated_at`**                   | `datetime`         |
# **`created_at`**                          | `datetime`         | `not null`
# **`updated_at`**                          | `datetime`         | `not null`
# **`esi_authorization_id`**                | `bigint`           |
# **`owner_id`**                            | `bigint`           |
# **`solar_system_id`**                     | `bigint`           |
# **`type_id`**                             | `bigint`           |
#
# ### Indexes
#
# * `index_structures_on_esi_authorization_id`:
#     * **`esi_authorization_id`**
# * `index_structures_on_owner_id`:
#     * **`owner_id`**
# * `index_structures_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_structures_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`esi_authorization_id => esi_authorizations.id`**
# * `fk_rails_...`:
#     * **`owner_id => corporations.id`**
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class Structure < ApplicationRecord
  include MarketOrdersSyncable
  include PgSearch::Model

  multisearchable against: %i[name owner_name type_name]

  pg_search_scope :search_by_all, against: %i[name],
                                  associated_against: {
                                    owner: :name,
                                    solar_system: :name,
                                    type: :name
                                  },
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  belongs_to :esi_authorization, inverse_of: :structures, optional: true
  belongs_to :owner, class_name: 'Corporation', inverse_of: :structures, optional: true
  belongs_to :solar_system, inverse_of: :structures, optional: true
  belongs_to :type, inverse_of: :structures, optional: true

  has_many :market_locations, as: :location, dependent: :destroy
  has_many :market_orders, as: :location
  has_many :markets, through: :market_locations

  delegate :name, to: :owner, prefix: true, allow_nil: true
  delegate :name, to: :type, prefix: true, allow_nil: true

  scope :orders_enabled, -> { where(market_order_sync_enabled: true) }

  def available_esi_authorizations
    rel = ESIAuthorization.includes(:character).joins(character: :corporation)
    rel.where('corporation_id IN (?)', [owner_id, owner&.alliance&.api_corporation_id].compact)
    rel.order('characters.name')
  end

  def esi_authorized?
    esi_authorization.present?
  end

  def esi_last_modified
    orders_reader.get("orders.#{id}.esi_last_modified")
  end

  def esi_expires
    orders_reader.get("orders.#{id}.esi_expires")
  end
end
