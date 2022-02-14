# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliance_locations`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`default`**      | `boolean`          |
# **`alliance_id`**  | `bigint`           | `not null, primary key`
# **`location_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_alliance_locations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_alliance_locations_on_location_id`:
#     * **`location_id`**
# * `index_unique_alliance_locations` (_unique_):
#     * **`alliance_id`**
#     * **`location_id`**
#
FactoryBot.define do
  factory :alliance_location do
  end
end
