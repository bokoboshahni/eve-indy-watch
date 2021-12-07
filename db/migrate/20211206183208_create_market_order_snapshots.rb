class CreateMarketOrderSnapshots < ActiveRecord::Migration[6.1]
  def change
    add_reference :regions, :esi_authorization, foreign_key: true
    add_column :regions, :esi_market_orders_expires_at, :datetime
    add_column :regions, :esi_market_orders_last_modified_at, :datetime
    add_column :regions, :market_order_sync_enabled, :boolean
    add_column :structures, :esi_market_orders_expires_at, :datetime
    add_column :structures, :esi_market_orders_last_modified_at, :datetime
    add_column :structures, :market_order_sync_enabled, :boolean

    create_table :market_order_snapshots, id: false, primary_key: %i[location_id order_id esi_last_modified_at] do |t|
      t.references :location, polymorphic: true, null: false
      t.references :solar_system, null: false
      t.references :type, null: false

      t.integer :duration, null: false
      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false
      t.datetime :issued_at, null: false
      t.text :kind, null: false
      t.integer :min_volume, null: false
      t.bigint :order_id, null: false
      t.decimal :price, null: false
      t.text :range, null: false
      t.integer :volume_remain, null: false
      t.integer :volume_total, null: false

      t.index %i[location_id order_id esi_last_modified_at], unique: true, name: :index_unique_market_order_snapshots
    end
  end
end
