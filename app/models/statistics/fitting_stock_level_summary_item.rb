# ## Schema Information
#
# Table name: `fitting_stock_level_summary_items`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`fitting_quantity`**    | `integer`          | `not null`
# **`interval`**            | `text`             | `not null, primary key`
# **`market_buy_price`**    | `decimal(, )`      |
# **`market_sell_price`**   | `decimal(, )`      |
# **`market_sell_volume`**  | `integer`          | `not null`
# **`time`**                | `datetime`         | `not null, primary key`
# **`fitting_id`**          | `bigint`           | `not null, primary key`
# **`market_id`**           | `bigint`           | `not null, primary key`
# **`type_id`**             | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `fitting_stock_level_summary_items_time_idx`:
#     * **`time`**
# * `index_unique_fitting_stock_level_summary_items` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`type_id`**
#     * **`time DESC`**
#     * **`interval`**
#
module Statistics
  class FittingStockLevelSummaryItem < ApplicationRecord
    self.inheritance_column = nil
    self.primary_keys = :fitting_id, :market_id, :type_id, :time, :interval
    self.table_name = :fitting_stock_level_summary_items

    belongs_to :fitting_stock_level, inverse_of: :items,
                                     foreign_key: %i[fitting_id market_id time interval]
  end
end
