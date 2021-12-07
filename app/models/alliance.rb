# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`icon_url_128`**          | `text`             |
# **`icon_url_64`**           | `text`             |
# **`name`**                  | `text`             | `not null`
# **`ticker`**                | `text`             | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`api_corporation_id`**    | `bigint`           |
#
class Alliance < ApplicationRecord
  belongs_to :api_corporation, class_name: 'Corporation', inverse_of: :api_alliance, optional: true

  has_one :esi_authorization, through: :api_corporation

  has_many :assigned_contracts, class_name: 'Contract', as: :assignee, dependent: :restrict_with_exception
  has_many :characters, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :contract_events, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :corporations, inverse_of: :alliance, dependent: :restrict_with_exception

  def sync_from_esi!
    Alliance::SyncFromESI.call(id)
  end

  def available_esi_authorizations
    rel = ESIAuthorization.includes(:character).joins(character: :corporation)
    rel.where('corporation_id = ?', api_corporation_id)
    rel.order('characters.name')
  end
end
