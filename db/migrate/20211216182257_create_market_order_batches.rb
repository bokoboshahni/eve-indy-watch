class CreateMarketOrderBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :market_order_batches do |t|
      t.references :location, null: false, polymorphic: true

      t.datetime :completed_at
      t.datetime :fetched_at
      t.timestamp :time, null: false
      t.timestamps null: false

      t.index %i[location_id location_type time], unique: true, name: :index_unique_market_order_batches
    end

    create_table :market_order_batch_pages, id: false, primary_key: %i[batch_id page] do |t|
      t.references :batch, null: false

      t.datetime :imported_at
      t.text :orders, null: false
      t.integer :page, null: false
      t.timestamps null: false
    end
  end
end
