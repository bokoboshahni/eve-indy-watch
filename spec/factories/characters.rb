# frozen_string_literal: true

# ## Schema Information
#
# Table name: `characters`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`name`**                  | `text`             | `not null`
# **`portrait_url_128`**      | `text`             |
# **`portrait_url_256`**      | `text`             |
# **`portrait_url_512`**      | `text`             |
# **`portrait_url_64`**       | `text`             |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`alliance_id`**           | `bigint`           |
# **`corporation_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_characters_on_alliance_id`:
#     * **`alliance_id`**
# * `index_characters_on_corporation_id`:
#     * **`corporation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
#
FactoryBot.define do
  factory :character do
    id { Faker::Number.within(range: 90_000_000..98_000_000) }
    corporation
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Name.name }

    trait :with_alliance do
      alliance
      corporation { association :corporation, alliance: alliance }
    end
  end
end
