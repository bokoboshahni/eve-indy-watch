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
FactoryBot.define do
  factory :user do
    character { association :character, :with_alliance }

    trait :admin do
      admin { true }
    end

    factory :admin_user, traits: %i[admin]
  end
end
