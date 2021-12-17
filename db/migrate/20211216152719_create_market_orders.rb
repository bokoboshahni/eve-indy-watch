class CreateMarketOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :market_orders, id: false, primary_key: %i[location_id order_id time] do |t|
      t.references :location, polymorphic: true, null: false, index: false
      t.references :solar_system, null: false, index: false
      t.references :type, null: false, index: false

      t.integer :duration, null: false
      t.timestamp :time, null: false
      t.datetime :issued_at, null: false
      t.text :kind, null: false
      t.integer :min_volume, null: false
      t.bigint :order_id, null: false
      t.decimal :price, null: false
      t.text :range, null: false
      t.integer :volume_remain, null: false
      t.integer :volume_total, null: false

      t.index %i[location_id order_id time], unique: true, name: :index_unique_market_orders
    end
  end
end
