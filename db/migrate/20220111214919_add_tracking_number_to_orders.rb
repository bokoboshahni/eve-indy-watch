# frozen_string_literal: true

class AddTrackingNumberToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :procurement_orders, :tracking_number, :bigint
    add_index :procurement_orders, :tracking_number, unique: true, name: :index_unique_procurement_order_tracking_numbers
  end
end
