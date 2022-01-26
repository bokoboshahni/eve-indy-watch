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
# **`name`**        | `text`             |
# **`properties`**  | `jsonb`            |
# **`time`**        | `datetime`         |
# **`visit_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_ahoy_events_on_properties` (_using_ gin):
#     * **`properties`**
# * `index_ahoy_events_on_visit_id`:
#     * **`visit_id`**
#
require 'rails_helper'

RSpec.describe Ahoy::Event, type: :model do
end
