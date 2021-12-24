# ## Schema Information
#
# Table name: `fitting_markets`
#
# ### Columns
#
# Name                                | Type               | Attributes
# ----------------------------------- | ------------------ | ---------------------------
# **`contract_stock_level_enabled`**  | `boolean`          | `not null`
# **`market_stock_level_enabled`**    | `boolean`          | `not null`
# **`created_at`**                    | `datetime`         | `not null`
# **`updated_at`**                    | `datetime`         | `not null`
# **`fitting_id`**                    | `bigint`           | `not null, primary key`
# **`market_id`**                     | `bigint`           | `not null, primary key`
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
#
class FittingMarket < ApplicationRecord
  self.primary_keys = :fitting_id, :market_id

  belongs_to :fitting, inverse_of: :fitting_markets
  belongs_to :market, inverse_of: :fitting_markets
end
