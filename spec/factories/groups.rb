# frozen_string_literal: true

# ## Schema Information
#
# Table name: `groups`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         |
# **`esi_last_modified_at`**  | `datetime`         |
# **`name`**                  | `text`             | `not null`
# **`published`**             | `boolean`          | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`category_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_groups_on_category_id`:
#     * **`category_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
#
FactoryBot.define do
  factory :group do
    association :category

    id { Faker::Number.within(range: 0..1_000_000) }
    name { Faker::Food.dish }
    published { true }
  end
end
