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
class OauthApplication < ApplicationRecord
  include Doorkeeper::Orm::ActiveRecord::Mixins::Application

  before_validation :generate_name_for_personal_access_token, on: :create
  before_validation :generate_redirect_uri_for_personal_access_token, on: :create

  private

  def generate_name_for_personal_access_token
    self.name = "PAT-#{Nanoid.generate}" if personal?
  end

  def generate_redirect_uri_for_personal_access_token
    self.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob' if personal?
  end
end
