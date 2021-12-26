# ## Schema Information
#
# Table name: `market_order_batch_pages`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`import_count`**  | `integer`          |
# **`imported_at`**   | `datetime`         |
# **`order_count`**   | `integer`          |
# **`page`**          | `integer`          | `not null, primary key`
# **`started_at`**    | `datetime`         |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`batch_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_market_order_batch_pages_on_batch_id`:
#     * **`batch_id`**
#
class MarketOrder < ApplicationRecord
  class BatchPage < ApplicationRecord
    self.table_name = :market_order_batch_pages
    self.primary_keys = :batch_id, :page

    belongs_to :batch, class_name: 'Batch', inverse_of: :pages

    delegate :location, to: :batch

    validates :page, presence: true

    def imported?
      imported_at.present?
    end

    def started?
      started_at.present?
    end

    def import!
      MarketOrder::ImportPage.call(self)
    end
  end
end
