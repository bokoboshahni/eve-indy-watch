# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`icon_url_128`**          | `text`             |
# **`icon_url_64`**           | `text`             |
# **`name`**                  | `text`             | `not null`
# **`ticker`**                | `text`             | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
#
class Alliance < ApplicationRecord
  has_many :characters, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :corporations, inverse_of: :alliance, dependent: :restrict_with_exception

  def sync_from_esi!
    Alliance::SyncFromESI.call(id)
  end
end
