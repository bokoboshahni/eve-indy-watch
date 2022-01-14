# frozen_string_literal: true

class ChangeUniqueIndexOnFittingStockLevels < ActiveRecord::Migration[6.1]
  def up
    remove_index :fitting_stock_levels, name: :index_unique_fitting_stock_levels

    add_index :fitting_stock_levels, %i[fitting_id market_id interval market_time], order: { market_time: :desc }, unique: true, name: :index_unique_fitting_stock_levels
  end
end
