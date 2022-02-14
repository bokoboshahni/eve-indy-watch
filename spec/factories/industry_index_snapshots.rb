# frozen_string_literal: true

# ## Schema Information
#
# Table name: `industry_index_snapshots`
#
# ### Columns
#
# Name                                   | Type               | Attributes
# -------------------------------------- | ------------------ | ---------------------------
# **`id`**                               | `bigint`           | `not null, primary key`
# **`copying`**                          | `decimal(, )`      |
# **`duplicating`**                      | `decimal(, )`      |
# **`esi_expires_at`**                   | `datetime`         | `not null`
# **`esi_last_modified_at`**             | `datetime`         | `not null`
# **`invention`**                        | `decimal(, )`      |
# **`manufacturing`**                    | `decimal(, )`      |
# **`none`**                             | `decimal(, )`      |
# **`reaction`**                         | `decimal(, )`      |
# **`researching_material_efficiency`**  | `decimal(, )`      |
# **`researching_technology`**           | `decimal(, )`      |
# **`researching_time_efficiency`**      | `decimal(, )`      |
# **`reverse_engineering`**              | `decimal(, )`      |
# **`solar_system_id`**                  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_industry_index_snapshots` (_unique_):
#     * **`solar_system_id`**
#     * **`esi_last_modified_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
#
FactoryBot.define do
  factory :industry_index_snapshot do
  end
end
