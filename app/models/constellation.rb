# frozen_string_literal: true

# ## Schema Information
#
# Table name: `constellations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`region_id`**   | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_constellations_on_region_id`:
#     * **`region_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`region_id => regions.id`**
#
class Constellation < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name]

  belongs_to :region, inverse_of: :constellations

  has_many :market_orders, through: :solar_systems
  has_many :solar_systems, inverse_of: :constellation
end
