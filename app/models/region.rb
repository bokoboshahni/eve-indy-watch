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
# **`type_history_preload_enabled`**        | `boolean`          |
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
  include PgSearch::Model

  multisearchable against: %i[name]

  pg_search_scope :search_by_all, against: %i[name],
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  belongs_to :esi_authorization, inverse_of: :regions, optional: true

  has_many :constellations, inverse_of: :region, dependent: :restrict_with_exception

  has_many :contracts, through: :solar_systems
  has_many :markets_for_type_history, class_name: 'Market', inverse_of: :type_history_region,
                                      dependent: :restrict_with_exception
  has_many :market_locations, as: :location, dependent: :destroy
  has_many :markets, through: :market_locations
  has_many :solar_systems, through: :constellations
  has_many :stations, through: :solar_systems
  has_many :structures, through: :solar_systems
  has_many :type_histories, class_name: 'RegionTypeHistory', inverse_of: :region,
                            dependent: :restrict_with_exception

  scope :new_eden, -> { where(id: 10_000_000..11_000_000) }

  delegate :available_esi_authorizations, to: :main_alliance

  def esi_authorized?
    esi_authorization.present?
  end

  def type_history_expired?(type)
    latest = RegionTypeHistory.where(region_id: id, type_id: type.id)
                              .maximum(:date)

    return true unless latest

    latest < 1.day.ago.to_date
  end

  def import_type_history!(type)
    ImportTypeHistory.call(self, type)
  end

  def import_type_history_async(type)
    ImportTypeHistoryWorker.perform_async(id, type.id)
  end

  def orders_last_modified
    orders_reader.get("orders.#{id}.esi_last_modified")&.to_datetime
  end

  def orders_expires
    orders_reader.get("orders.#{id}.esi_expires")&.to_datetime
  end
end
