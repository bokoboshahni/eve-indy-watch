# frozen_string_literal: true

# ## Schema Information
#
# Table name: `solar_systems`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`name`**              | `text`             | `not null`
# **`security`**          | `decimal(, )`      | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`constellation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_solar_systems_on_constellation_id`:
#     * **`constellation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`constellation_id => constellations.id`**
#
class SolarSystem < ApplicationRecord
  belongs_to :constellation, inverse_of: :solar_systems

  has_one :latest_industry_index_snapshot, lambda {
                                             order esi_last_modified_at: :desc
                                           }, class_name: 'IndustryIndexSnapshot', foreign_key: :solar_system_id

  has_many :industry_index_snapshots, inverse_of: :solar_system, dependent: :destroy
  has_many :market_orders, inverse_of: :solar_system, dependent: :destroy
  has_many :stations, inverse_of: :solar_system, dependent: :restrict_with_exception
  has_many :structures, inverse_of: :solar_system, dependent: :restrict_with_exception

  delegate :copying, :duplicating, :invention, :manufacturing, :none, :reaction, :researching_material_efficiency,
           :researching_technology, :researching_time_efficiency, :reverse_engineering, to: :latest_industry_index_snapshot, prefix: :industry_index
end
