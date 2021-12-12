# frozen_string_literal: true

class CreateMarketFittingSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :market_fitting_snapshots, id: false, primary_key: %i[market_id fitting_id time] do |t|
      t.references :market, null: false, foreign_key: true
      t.references :fitting, null: false, foreign_key: true

      t.integer :quantity, null: false
      t.jsonb :items, null: false
      t.decimal :price_buy
      t.decimal :price_sell
      t.decimal :price_split
      t.datetime :time, null: false

      t.index %i[market_id fitting_id time], unique: true, name: :index_unique_market_fitting_snapshots
    end
  end
end
