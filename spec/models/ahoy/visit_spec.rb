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
# **`browser`**           | `text`             |
# **`device_type`**       | `text`             |
# **`ip`**                | `text`             |
# **`landing_page`**      | `text`             |
# **`os`**                | `text`             |
# **`referrer`**          | `text`             |
# **`referring_domain`**  | `text`             |
# **`started_at`**        | `datetime`         |
# **`user_agent`**        | `text`             |
# **`visit_token`**       | `text`             |
# **`visitor_token`**     | `text`             |
#
# ### Indexes
#
# * `index_unique_visit_tokens` (_unique_):
#     * **`visit_token`**
#
require 'rails_helper'

RSpec.describe Ahoy::Visit, type: :model do
end
