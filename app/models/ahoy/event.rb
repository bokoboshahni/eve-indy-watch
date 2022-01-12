# frozen_string_literal: true

# ## Schema Information
#
# Table name: `ahoy_events`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `string`           |
# **`properties`**  | `jsonb`            |
# **`time`**        | `datetime`         |
# **`visit_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_ahoy_events_on_name_and_time`:
#     * **`name`**
#     * **`time`**
# * `index_ahoy_events_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_ahoy_events_on_visit_id`:
#     * **`visit_id`**
#
module Ahoy
  class Event < Statistics::ApplicationRecord
    include Ahoy::QueryMethods

    self.table_name = 'ahoy_events'

    belongs_to :visit
  end
end
