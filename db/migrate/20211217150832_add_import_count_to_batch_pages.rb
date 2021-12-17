class AddImportCountToBatchPages < ActiveRecord::Migration[6.1]
  def change
    add_column :market_order_batch_pages, :import_count, :integer
  end
end
