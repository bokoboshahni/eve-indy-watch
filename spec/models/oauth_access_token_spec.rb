# frozen_string_literal: true

# ## Schema Information
#
# Table name: `oauth_access_tokens`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`description`**        | `text`             |
# **`expires_in`**         | `integer`          |
# **`refresh_token`**      | `text`             |
# **`revoked_at`**         | `datetime`         |
# **`scopes`**             | `text`             |
# **`token`**              | `text`             | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`application_id`**     | `bigint`           | `not null`
# **`resource_owner_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_oauth_access_tokens_on_application_id`:
#     * **`application_id`**
# * `index_oauth_access_tokens_on_resource_owner_id`:
#     * **`resource_owner_id`**
# * `index_unique_oauth_access_tokens` (_unique_):
#     * **`token`**
# * `index_unique_oauth_refresh_tokens` (_unique_):
#     * **`refresh_token`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`application_id => oauth_applications.id`**
# * `fk_rails_...`:
#     * **`resource_owner_id => users.id`**
#
require 'rails_helper'

RSpec.describe OauthAccessToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
