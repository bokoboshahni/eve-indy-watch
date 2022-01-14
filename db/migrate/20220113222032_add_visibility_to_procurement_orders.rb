# frozen_string_literal: true

class AddVisibilityToProcurementOrders < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL.squish
      CREATE TYPE procurement_order_visibility AS ENUM (
        'everyone',
        'corporation',
        'alliance'
      );
    SQL

    add_column :procurement_orders, :visibility, :procurement_order_visibility
  end

  def down
    remove_column :procurement_orders, :visibility, :procurement_order_visibility

    execute 'DROP TYPE procurement_order_visibility;'
  end
end
