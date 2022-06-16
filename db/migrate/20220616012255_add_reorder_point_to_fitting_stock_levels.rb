# frozen_string_literal: true

class AddReorderPointToFittingStockLevels < ActiveRecord::Migration[7.0]
  def change
    add_column :fitting_stock_levels, :reorder_point, :integer
  end
end
