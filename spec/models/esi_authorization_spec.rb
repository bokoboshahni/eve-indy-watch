# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe ESIAuthorization, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
