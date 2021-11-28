# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`icon_url_128`**          | `text`             |
# **`icon_url_256`**          | `text`             |
# **`icon_url_64`**           | `text`             |
# **`name`**                  | `text`             | `not null`
# **`ticker`**                | `text`             | `not null`
# **`url`**                   | `text`             |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`alliance_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
#
class Corporation < ApplicationRecord
  belongs_to :alliance, inverse_of: :corporations, optional: true

  has_many :characters, inverse_of: :corporation, dependent: :destroy

  def sync_from_esi!
    Corporation::SyncFromESI.call(id)
  end
end
