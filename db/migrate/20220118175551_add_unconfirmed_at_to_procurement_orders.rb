# frozen_string_literal: true

class AddUnconfirmedAtToProcurementOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :procurement_orders, :unconfirmed_at, :datetime
  end
end
