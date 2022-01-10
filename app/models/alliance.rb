# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                                    | Type               | Attributes
# --------------------------------------- | ------------------ | ---------------------------
# **`id`**                                | `bigint`           | `not null, primary key`
# **`esi_expires_at`**                    | `datetime`         | `not null`
# **`esi_last_modified_at`**              | `datetime`         | `not null`
# **`icon_url_128`**                      | `text`             |
# **`icon_url_64`**                       | `text`             |
# **`name`**                              | `text`             | `not null`
# **`procurement_order_requester_type`**  | `string`           |
# **`ticker`**                            | `text`             | `not null`
# **`zkb_fetched_at`**                    | `datetime`         |
# **`zkb_sync_enabled`**                  | `boolean`          |
# **`created_at`**                        | `datetime`         | `not null`
# **`updated_at`**                        | `datetime`         | `not null`
# **`api_corporation_id`**                | `bigint`           |
# **`appraisal_market_id`**               | `bigint`           |
# **`main_market_id`**                    | `bigint`           |
# **`procurement_order_requester_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_alliances_on_appraisal_market_id`:
#     * **`appraisal_market_id`**
# * `index_alliances_on_main_market_id`:
#     * **`main_market_id`**
# * `index_alliances_on_procurement_order_assignee`:
#     * **`procurement_order_requester_type`**
#     * **`procurement_order_requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`appraisal_market_id => markets.id`**
# * `fk_rails_...`:
#     * **`main_market_id => markets.id`**
#
class Alliance < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name]

  pg_search_scope :search_by_all, against: %i[name],
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  belongs_to :api_corporation, class_name: 'Corporation', inverse_of: :api_alliance, optional: true
  belongs_to :main_market, class_name: 'Market', inverse_of: :alliances_as_main_market, optional: true
  belongs_to :appraisal_market, class_name: 'Market', inverse_of: :alliances_as_appraisal_market, optional: true
  belongs_to :procurement_order_requester, polymorphic: true, optional: true

  has_one :default_alliance_location, -> { where(default: true) }, class_name: 'AllianceLocation'
  has_one :default_location, class_name: 'Location', through: :default_alliance_location, source: :location
  has_one :esi_authorization, through: :api_corporation

  has_many :alliance_locations, inverse_of: :alliance, dependent: :destroy
  has_many :assigned_contracts, class_name: 'Contract', as: :assignee, dependent: :restrict_with_exception
  has_many :requested_procurement_orders, class_name: 'ProcurementOrder', as: :requester
  has_many :characters, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :contract_events, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :corporations, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :fittings, as: :owner, dependent: :destroy
  has_many :killmail_attackers, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :killmails, through: :killmail_attackers
  has_many :locations, through: :alliance_locations, foreign_key: :locatable_id
  has_many :lossmails, class_name: 'Killmail', inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :markets, as: :owner, dependent: :destroy

  delegate :name, to: :main_market, prefix: true, allow_nil: true
  delegate :name, to: :appraisal_market, prefix: true, allow_nil: true
  delegate :name, to: :procurement_order_requester, prefix: true, allow_nil: true

  def sync_from_esi!
    Alliance::SyncFromESI.call(id)
  end

  def available_esi_authorizations
    rel = ESIAuthorization.includes(:character).joins(character: :corporation)
    rel.where(corporation_id: api_corporation_id)
    rel.order('characters.name')
  end

  def log_name
    "#{name} (#{id})"
  end

  def zkb_killmails_expired?
    return true if zkb_expires_at.blank?

    zkb_expires_at <= Time.zone.now
  end

  def fetch_killmails_from_zkb(year: nil, month: nil)
    Alliance::FetchKillmailsFromZKB.call(self, year: year, month: month)
  end

  def fetch_killmails_from_zkb_async(year: nil, month: nil)
    Alliance::FetchKillmailsFromZKBWorker.perform_async(id, year, month)
  end
end
