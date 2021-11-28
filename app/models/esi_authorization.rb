# ## Schema Information
#
# Table name: `esi_authorizations`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id`**                        | `bigint`           | `not null, primary key`
# **`access_token_ciphertext`**   | `text`             | `not null`
# **`expires_at`**                | `datetime`         | `not null`
# **`refresh_token_ciphertext`**  | `text`             | `not null`
# **`scopes`**                    | `text`             | `default([]), not null, is an Array`
# **`created_at`**                | `datetime`         | `not null`
# **`updated_at`**                | `datetime`         | `not null`
# **`character_id`**              | `bigint`           | `not null`
# **`user_id`**                   | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_esi_authorizations_on_character_id`:
#     * **`character_id`**
# * `index_esi_authorizations_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
class ESIAuthorization < ApplicationRecord
  belongs_to :character, inverse_of: :esi_authorizations
  belongs_to :user, inverse_of: :esi_authorizations

  encrypts :access_token, :refresh_token

  validates :access_token, presence: true
  validates :expires_at, presence: true
  validates :refresh_token, presence: true

  def refresh_token!
    RefreshToken.call(self)
  end
end
