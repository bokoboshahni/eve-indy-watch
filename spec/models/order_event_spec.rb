# ## Schema Information
#
# Table name: `order_events`
#
# ### Columns
#
# Name            | Type               | Attributes
# --------------- | ------------------ | ---------------------------
# **`action`**    | `enum`             | `not null`
# **`fill`**      | `integer`          |
# **`price`**     | `decimal(15, 2)`   | `not null`
# **`time`**      | `datetime`         | `not null, primary key`
# **`type`**      | `enum`             | `not null`
# **`volume`**    | `integer`          | `not null`
# **`order_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_order_events_on_order_id`:
#     * **`order_id`**
# * `index_unique_order_events` (_unique_):
#     * **`order_id`**
#     * **`time DESC`**
# * `order_events_time_idx`:
#     * **`time`**
#
require 'rails_helper'

RSpec.describe OrderEvent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
