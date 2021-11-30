# frozen_string_literal: true

# ## Schema Information
#
# Table name: `structures`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         |
# **`esi_last_modified_at`**  | `datetime`         |
# **`name`**                  | `text`             | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`esi_authorization_id`**  | `bigint`           |
# **`owner_id`**              | `bigint`           |
# **`solar_system_id`**       | `bigint`           |
# **`type_id`**               | `bigint`           |
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
  belongs_to :owner, class_name: 'Corporation', inverse_of: :structures
  belongs_to :solar_system, inverse_of: :structures
  belongs_to :type, inverse_of: :structures, optional: true

  def available_esi_authorizations
    rel = ESIAuthorization.includes(:character).joins(character: :corporation)
    rel.where('corporation_id IN (?)', [owner_id, owner&.alliance&.api_corporation_id].compact)
    rel.order('characters.name')
  end
end
