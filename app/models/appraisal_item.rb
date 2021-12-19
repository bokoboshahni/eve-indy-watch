# ## Schema Information
#
# Table name: `appraisal_items`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`buy_five_pct_order_count`**   | `bigint`           |
# **`buy_five_pct_price_avg`**     | `decimal(, )`      |
# **`buy_five_pct_price_med`**     | `decimal(, )`      |
# **`buy_price_avg`**              | `decimal(, )`      |
# **`buy_price_max`**              | `decimal(, )`      |
# **`buy_price_med`**              | `decimal(, )`      |
# **`buy_price_min`**              | `decimal(, )`      |
# **`buy_price_sum`**              | `decimal(, )`      |
# **`buy_sell_price_spread`**      | `decimal(, )`      | `not null`
# **`buy_total_order_count`**      | `bigint`           |
# **`buy_trimmed_order_count`**    | `bigint`           |
# **`buy_volume_avg`**             | `decimal(, )`      |
# **`buy_volume_max`**             | `bigint`           |
# **`buy_volume_med`**             | `bigint`           |
# **`buy_volume_min`**             | `bigint`           |
# **`buy_volume_sum`**             | `bigint`           |
# **`quantity`**                   | `bigint`           | `not null`
# **`sell_five_pct_order_count`**  | `decimal(, )`      |
# **`sell_five_pct_price_avg`**    | `decimal(, )`      |
# **`sell_five_pct_price_med`**    | `decimal(, )`      |
# **`sell_price_avg`**             | `decimal(, )`      |
# **`sell_price_max`**             | `decimal(, )`      |
# **`sell_price_med`**             | `decimal(, )`      |
# **`sell_price_min`**             | `decimal(, )`      |
# **`sell_price_sum`**             | `decimal(, )`      |
# **`sell_total_order_count`**     | `bigint`           |
# **`sell_trimmed_order_count`**   | `bigint`           |
# **`sell_volume_avg`**            | `decimal(, )`      |
# **`sell_volume_max`**            | `bigint`           |
# **`sell_volume_med`**            | `bigint`           |
# **`sell_volume_min`**            | `bigint`           |
# **`sell_volume_sum`**            | `bigint`           |
# **`appraisal_id`**               | `bigint`           | `not null, primary key`
# **`type_id`**                    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_appraisal_items_on_appraisal_id`:
#     * **`appraisal_id`**
# * `index_appraisal_items_on_type_id`:
#     * **`type_id`**
#
class AppraisalItem < ApplicationRecord
  self.inheritance_column = nil
  self.primary_keys = :appraisal_id, :type_id

  belongs_to :appraisal, inverse_of: :items
  belongs_to :type, inverse_of: :appraisal_items

  has_one :category, through: :group
  has_one :group, through: :type
  has_one :market_group, through: :type

  delegate :name, :packaged_volume, :volume, :icon_url, to: :type

  self.column_names.grep(/price/).each do |stat|
    define_method :"total_#{stat}" do
      (send(stat) || 0.0) * (quantity.to_d || 0.0)
    end
  end

  def total_packaged_volume
    (packaged_volume || volume).to_d * quantity.to_d
  end

  def total_volume
    volume.to_d * quantity.to_d
  end
end
