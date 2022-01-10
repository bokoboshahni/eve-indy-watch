# frozen_string_literal: true

# ## Schema Information
#
# Table name: `locations`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`locatable_type`**  | `string`           | `not null`
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`locatable_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_locations_on_locatable`:
#     * **`locatable_type`**
#     * **`locatable_id`**
# * `index_unique_locations` (_unique_):
#     * **`locatable_id`**
#     * **`locatable_type`**
#
class Location < ApplicationRecord
  self.primary_key = :locatable_id

  belongs_to :locatable, polymorphic: true

  has_many :alliance_locations, inverse_of: :location
  has_many :markets, inverse_of: :source_location, foreign_key: :source_location_id
  has_many :procurement_orders, inverse_of: :location

  def locatable_sgid
    locatable.to_signed_global_id
  end
end
