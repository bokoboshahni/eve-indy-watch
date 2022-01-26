# frozen_string_literal: true

# ## Schema Information
#
# Table name: `oauth_applications`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`confidential`**  | `boolean`          | `default(TRUE), not null`
# **`name`**          | `text`             | `not null`
# **`owner_type`**    | `string`           |
# **`personal`**      | `boolean`          | `default(FALSE), not null`
# **`redirect_uri`**  | `text`             |
# **`scopes`**        | `text`             | `default(""), not null`
# **`secret`**        | `text`             | `not null`
# **`uid`**           | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`owner_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_oauth_applications_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_unique_oauth_application_uids` (_unique_):
#     * **`uid`**
#
require 'rails_helper'

RSpec.describe OauthApplication, type: :model do
end
