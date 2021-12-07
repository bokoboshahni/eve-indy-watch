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
  belongs_to :esi_authorization, inverse_of: :structures, optional: true
  belongs_to :owner, class_name: 'Corporation', inverse_of: :structures, optional: true
  belongs_to :solar_system, inverse_of: :structures, optional: true
  belongs_to :type, inverse_of: :structures, optional: true

  has_many :market_order_snapshots, as: :location, dependent: :destroy

  def available_esi_authorizations
    rel = ESIAuthorization.includes(:character).joins(character: :corporation)
    rel.where('corporation_id IN (?)', [owner_id, owner&.alliance&.api_corporation_id].compact)
    rel.order('characters.name')
  end

  def esi_authorized?
    esi_authorization.present?
  end

  def esi_market_orders_expired?
    return true unless esi_market_orders_expires_at

    esi_market_orders_expires_at <= Time.zone.now
  end
end
