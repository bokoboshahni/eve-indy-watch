# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_stock_level_items`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`fitting_quantity`**    | `integer`          |
# **`interval`**            | `enum`             | `not null, primary key`
# **`market_buy_price`**    | `decimal(, )`      |
# **`market_sell_price`**   | `decimal(, )`      |
# **`market_sell_volume`**  | `bigint`           |
# **`time`**                | `datetime`         | `not null, primary key`
# **`fitting_id`**          | `bigint`           | `not null, primary key`
# **`market_id`**           | `bigint`           | `not null, primary key`
# **`type_id`**             | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_stock_level_items_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_stock_level_items_on_market_id`:
#     * **`market_id`**
# * `index_fitting_stock_level_items_on_type_id`:
#     * **`type_id`**
# * `index_unique_fitting_stock_level_items` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`type_id`**
#     * **`interval`**
#     * **`time DESC`**
#
require 'rails_helper'

RSpec.describe FittingStockLevelItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
