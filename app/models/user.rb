# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                              | Type               | Attributes
# --------------------------------- | ------------------ | ---------------------------
# **`id`**                          | `bigint`           | `not null, primary key`
# **`admin`**                       | `boolean`          | `default(FALSE), not null`
# **`dark_mode_enabled`**           | `boolean`          |
# **`esi_authorizations_enabled`**  | `boolean`          |
# **`roles`**                       | `text`             | `default([]), is an Array`
# **`created_at`**                  | `datetime`         | `not null`
# **`updated_at`**                  | `datetime`         | `not null`
# **`character_id`**                | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_users_on_character_id`:
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
class User < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name corporation_name alliance_name]

  pg_search_scope :search_by_all, associated_against: {
    character: :name
  },
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  ROLES = %w[
    alliance.fittings.editor
    alliance.orders.editor
    character.orders.supplier
    character.orders.editor
    character.orders.viewer
    corporation.fittings.editor
    corporation.orders.editor
    esi.authorizer
  ].freeze

  belongs_to :character, inverse_of: :user

  has_one :alliance, through: :character
  has_one :corporation, through: :character

  has_many :supplied_procurement_orders, class_name: 'ProcurementOrder', as: :supplier
  has_many :esi_authorizations, inverse_of: :user, dependent: :destroy
  has_many :oauth_access_grants, inverse_of: :resource_owner, foreign_key: :resource_owner_id, dependent: :destroy
  has_many :oauth_access_tokens, inverse_of: :resource_owner, foreign_key: :resource_owner_id, dependent: :destroy
  has_many :oauth_applications, inverse_of: :resource_owner, foreign_key: :resource_owner, dependent: :destroy
  has_many :oauth_authorized_applications, class_name: 'OauthApplication', through: :oauth_access_tokens, source: :application
  has_many :personal_access_token_applications, -> { where(personal: true) }, class_name: 'OauthApplication', as: :owner # rubocop:disable Rails/InverseOf
  has_many :personal_access_tokens, -> { joins(:application).where('oauth_applications.personal': true) }, class_name: 'OauthAccessToken', foreign_key: :resource_owner_id # rubocop:disable Rails/InverseOf
  has_many :report_runs, inverse_of: :user

  delegate :id, :name, to: :alliance, prefix: true, allow_nil: true
  delegate :id, :name, to: :corporation, prefix: true
  delegate :portrait_url_256, :name, to: :character # rubocop:disable Naming/VariableNumber
  delegate :icon_url_256, :name, to: :corporation, prefix: true # rubocop:disable Naming/VariableNumber
  delegate :icon_url_128, :name, to: :alliance, prefix: true, allow_nil: true # rubocop:disable Naming/VariableNumber

  def roles=(val)
    self[:roles] = val.reject { |v| ROLES.exclude?(v) }
  end

  def role?(*names)
    return true if admin?

    return true if names.any? do |name|
      default_roles = app_config.default_roles
      name.is_a?(Regexp) ? default_roles.grep(name).any? : default_roles.include?(name)
    end

    names.any? do |name|
      name.is_a?(Regexp) ? roles.grep(name).any? : roles.include?(name)
    end
  end
end
