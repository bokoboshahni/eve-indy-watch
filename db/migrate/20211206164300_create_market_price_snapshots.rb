class CreateMarketPriceSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :market_price_snapshots do |t|
      t.references :type, null: false, foreign_key: true

      t.decimal :adjusted_price
      t.decimal :average_price
      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false

      t.index %i[type_id esi_last_modified_at], unique: true, name: :index_unique_market_price_snapshots
    end
  end
end
