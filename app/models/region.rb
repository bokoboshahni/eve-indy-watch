# frozen_string_literal: true

# ## Schema Information
#
# Table name: `regions`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class Region < ApplicationRecord
  has_many :constellations, inverse_of: :region, dependent: :restrict_with_exception

  has_many :contracts, through: :solar_systems
  has_many :solar_systems, through: :constellations
  has_many :stations, through: :solar_systems
  has_many :structures, through: :solar_systems
end
