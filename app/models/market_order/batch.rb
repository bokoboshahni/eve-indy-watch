# ## Schema Information
#
# Table name: `market_order_batches`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `bigint`           | `not null, primary key`
# **`completed_at`**   | `datetime`         |
# **`fetched_at`**     | `datetime`         |
# **`location_type`**  | `string`           | `not null`
# **`time`**           | `datetime`         | `not null`
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`location_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_order_batches_on_location`:
#     * **`location_type`**
#     * **`location_id`**
# * `index_unique_market_order_batches` (_unique_):
#     * **`location_id`**
#     * **`location_type`**
#     * **`time`**
#
class MarketOrder < ApplicationRecord
  class Batch < ApplicationRecord
    self.table_name = :market_order_batches

    belongs_to :location, polymorphic: true

    has_many :pages, class_name: 'BatchPage', inverse_of: :batch, dependent: :destroy

    scope :incomplete, -> { where(completed_at: nil) }

    validates :time, presence: true

    def completed?
      completed_at.present?
    end

    def complete!
      CompleteBatch.call(self)
    end

    def complete_async
      CompleteBatchWorker.perform_async(id)
    end
  end
end
