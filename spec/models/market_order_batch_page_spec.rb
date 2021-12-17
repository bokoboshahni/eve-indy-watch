# ## Schema Information
#
# Table name: `market_order_batch_pages`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`orders`**      | `jsonb`            |
# **`page`**        | `integer`          | `not null`
# **`status`**      | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`batch_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_order_batch_pages_on_batch_id`:
#     * **`batch_id`**
#
require 'rails_helper'

RSpec.describe MarketOrderBatchPage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
