# frozen_string_literal: true

class CreateProcurementOrders < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      CREATE TYPE procurement_order_status AS ENUM (
        'draft',
        'available',
        'in_progress',
        'partially_delivered',
        'delivered'
      )
    SQL

    execute <<~SQL.squish
      CREATE TYPE procurement_order_item_status AS ENUM (
        'available',
        'in_progress',
        'partially_delivered',
        'delivered'
      )
    SQL

    create_table :procurement_orders do |t|
      t.references :requester, polymorphic: true, null: false
      t.references :location, null: false
      t.references :supplier, polymorphic: true

      t.boolean :split_fulfillment_enabled
      t.datetime :accepted_at
      t.text :appraisal_url
      t.text :requester_name
      t.datetime :deliver_by
      t.datetime :delivered_at
      t.datetime :discarded_at, index: true
      t.datetime :published_at
      t.text :notes
      t.decimal :multiplier, null: false
      t.decimal :bonus
      t.column :status, :procurement_order_status, null: false
      t.text :supplier_name
      t.timestamps null: false
    end

    create_table :procurement_order_items do |t|
      t.references :order, null: false, foreign_key: { to_table: :procurement_orders }
      t.references :type, null: false, foreign_key: { to_table: :types }
      t.references :supplier, polymorphic: true

      t.datetime :accepted_at
      t.decimal :bonus
      t.datetime :delivered_at
      t.decimal :multiplier, null: false
      t.decimal :price, null: false
      t.bigint :quantity_received
      t.bigint :quantity_required, null: false
      t.column :status, :procurement_order_item_status, null: false, default: 'available'
      t.text :supplier_name
      t.timestamps null: false
    end

    rename_column :alliances, :procurement_order_assignee_id, :procurement_order_requester_id
    rename_column :alliances, :procurement_order_assignee_type, :procurement_order_requester_type
  end

  def down
    rename_column :alliances, :procurement_order_requester_type, :procurement_order_assignee_type
    rename_column :alliances, :procurement_order_requester_id, :procurement_order_assignee_id

    drop_table :procurement_order_items
    drop_table :procurement_orders

    execute 'DROP TYPE procurement_order_item_status;'

    execute 'DROP TYPE procurement_order_status;'
  end
end
