# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`owner_type`**  | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`owner_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_markets_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
#
class Market < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true

  has_many :market_locations, inverse_of: :market
  has_many :locations, through: :market_locations

  validates :name, presence: true

  def aggregate_types!(aggregation, interval)
    Market::AggregateTypes.call(self, aggregation, interval)
  end

  def aggregate_types_async(aggregation, interval)
    Market::AggregateTypesWorker.perform_async(id, aggregation, interval)
  end

  def prune_type_aggregations!(interval, before)
    Market::PruneTypeAggregations.call(self, interval, before)
  end
end
