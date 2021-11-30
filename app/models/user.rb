# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`admin`**         | `boolean`          | `default(FALSE), not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
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
  belongs_to :character, inverse_of: :user

  has_one :alliance, through: :character
  has_one :corporation, through: :character

  has_many :esi_authorizations, inverse_of: :user, dependent: :destroy

  delegate :portrait_url_256, :name, to: :character # rubocop:disable Naming/VariableNumber
  delegate :icon_url_256, :name, to: :corporation, prefix: true # rubocop:disable Naming/VariableNumber
  delegate :icon_url_128, :name, to: :alliance, prefix: true, allow_nil: true # rubocop:disable Naming/VariableNumber
end
