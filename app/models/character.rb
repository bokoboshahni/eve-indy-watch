# frozen_string_literal: true

# ## Schema Information
#
# Table name: `characters`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`name`**                  | `text`             | `not null`
# **`portrait_url_128`**      | `text`             |
# **`portrait_url_256`**      | `text`             |
# **`portrait_url_512`**      | `text`             |
# **`portrait_url_64`**       | `text`             |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`alliance_id`**           | `bigint`           |
# **`corporation_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_characters_on_alliance_id`:
#     * **`alliance_id`**
# * `index_characters_on_corporation_id`:
#     * **`corporation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
#
class Character < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name]

  belongs_to :alliance, inverse_of: :characters, optional: true
  belongs_to :corporation, inverse_of: :characters

  has_one :user, inverse_of: :character, dependent: :restrict_with_exception

  has_many :accepted_contracts, class_name: 'Contract', as: :acceptor, dependent: :restrict_with_exception
  has_many :alliances_as_procurement_order_requester, as: :procurement_order_requester
  has_many :corporations_as_procurement_order_requester, as: :procurement_order_requester
  has_many :assigned_contracts, class_name: 'Contract', as: :assignee, dependent: :restrict_with_exception
  has_many :requested_procurement_orders, class_name: 'ProcurementOrder', as: :requester
  has_many :esi_authorizations, inverse_of: :character, dependent: :destroy
  has_many :fittings, as: :owner, dependent: :destroy
  has_many :issued_contracts, class_name: 'Contract', as: :issuer, dependent: :restrict_with_exception
  has_many :killmail_attackers, inverse_of: :character, dependent: :restrict_with_exception
  has_many :killmails, through: :killmail_attackers
  has_many :lossmails, class_name: 'Killmail', inverse_of: :character, dependent: :restrict_with_exception
  has_many :notifications, as: :recipient
  has_many :notification_subscriptions, as: :subscriber
  has_many :slack_webhooks, as: :owner
  has_many :supplied_procurement_orders, class_name: 'ProcurementOrder', as: :supplier
  has_many :supplied_procurement_order_items, class_name: 'ProcurementOrderItem', as: :supplier

  def sync_from_esi!
    Character::SyncFromESI.call(id)
  end
end
