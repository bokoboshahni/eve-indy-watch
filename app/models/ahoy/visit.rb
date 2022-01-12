# frozen_string_literal: true

# ## Schema Information
#
# Table name: `ahoy_visits`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`browser`**           | `string`           |
# **`device_type`**       | `string`           |
# **`ip`**                | `string`           |
# **`landing_page`**      | `text`             |
# **`os`**                | `string`           |
# **`referrer`**          | `text`             |
# **`referring_domain`**  | `string`           |
# **`started_at`**        | `datetime`         |
# **`user_agent`**        | `text`             |
# **`visit_token`**       | `string`           |
# **`visitor_token`**     | `string`           |
#
# ### Indexes
#
# * `index_ahoy_visits_on_visit_token` (_unique_):
#     * **`visit_token`**
#
module Ahoy
  class Visit < Statistics::ApplicationRecord
    self.table_name = 'ahoy_visits'

    has_many :events, class_name: 'Ahoy::Event'
    belongs_to :user, optional: true
  end
end
