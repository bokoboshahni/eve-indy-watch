# frozen_string_literal: true

class RenameDeliverByToTargetCompletionAtOnProcurementOrders < ActiveRecord::Migration[6.1]
  def change
    rename_column :procurement_orders, :deliver_by, :target_completion_at
  end
end
