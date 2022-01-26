# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_stock_levels`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`contract_match_quantity`**   | `integer`          |
# **`contract_match_threshold`**  | `decimal(, )`      |
# **`contract_price_avg`**        | `decimal(, )`      |
# **`contract_price_max`**        | `decimal(, )`      |
# **`contract_price_med`**        | `decimal(, )`      |
# **`contract_price_min`**        | `decimal(, )`      |
# **`contract_price_sum`**        | `decimal(, )`      |
# **`contract_similarity_avg`**   | `decimal(, )`      |
# **`contract_similarity_max`**   | `decimal(, )`      |
# **`contract_similarity_med`**   | `decimal(, )`      |
# **`contract_similarity_min`**   | `decimal(, )`      |
# **`contract_total_quantity`**   | `integer`          |
# **`interval`**                  | `enum`             | `not null, primary key`
# **`market_buy_price`**          | `decimal(, )`      |
# **`market_quantity`**           | `integer`          |
# **`market_sell_price`**         | `decimal(, )`      |
# **`market_time`**               | `datetime`         |
# **`time`**                      | `datetime`         | `not null, primary key`
# **`fitting_id`**                | `bigint`           | `not null, primary key`
# **`market_id`**                 | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_stock_levels_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_stock_levels_on_market_id`:
#     * **`market_id`**
# * `index_unique_fitting_stock_levels` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`interval`**
#     * **`market_time DESC`**
#
require 'rails_helper'

RSpec.describe FittingStockLevel, type: :model do
end
