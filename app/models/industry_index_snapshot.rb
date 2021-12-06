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
# * `index_industry_index_snapshots_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_unique_industry_index_snapshots` (_unique_):
#     * **`solar_system_id`**
#     * **`esi_last_modified_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
#
class IndustryIndexSnapshot < ApplicationRecord
  belongs_to :solar_system, inverse_of: :industry_index_snapshots

  def self.sync_from_esi!
    IndustryIndexSnapshot::SyncFromESI.call
  end
end
