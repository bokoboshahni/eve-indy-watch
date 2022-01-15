# frozen_string_literal: true

class AddEstimatedCompletionDateToProcurementOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :procurement_orders, :estimated_completion_at, :datetime
  end
end
