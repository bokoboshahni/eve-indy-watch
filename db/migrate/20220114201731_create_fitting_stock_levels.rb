# frozen_string_literal: true

class CreateFittingStockLevels < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      CREATE TYPE fitting_stock_level_interval AS ENUM (
        'live',
        'end_of_day',
        'end_of_week',
        'end_of_month'
      );
    SQL

    create_table :fitting_stock_levels, id: false, primary_key: %i[fitting_id market_id interval time] do |t|
      t.references :fitting, null: false
      t.references :market, null: false
      t.column :interval, :fitting_stock_level_interval, null: false
      t.timestamp :time, null: false

      t.integer :contract_match_quantity
      t.decimal :contract_match_threshold
      t.decimal :contract_price_avg
      t.decimal :contract_price_max
      t.decimal :contract_price_med
      t.decimal :contract_price_min
      t.decimal :contract_price_sum
      t.decimal :contract_similarity_avg
      t.decimal :contract_similarity_max
      t.decimal :contract_similarity_med
      t.decimal :contract_similarity_min
      t.integer :contract_total_quantity
      t.decimal :market_buy_price
      t.integer :market_quantity
      t.decimal :market_sell_price
      t.datetime :market_time

      t.index %i[fitting_id market_id interval time], order: { time: :desc }, unique: true, name: :index_unique_fitting_stock_levels
    end

    create_table :fitting_stock_level_items, id: false, primary_key: %i[fitting_id market_id type_id interval time] do |t|
      t.references :fitting, null: false
      t.references :market, null: false
      t.references :type, null: false
      t.column :interval, :fitting_stock_level_interval, null: false
      t.timestamp :time, null: false

      t.integer :fitting_quantity
      t.decimal :market_buy_price
      t.decimal :market_sell_price
      t.bigint :market_sell_volume

      t.index %i[fitting_id market_id type_id interval time], order: { time: :desc }, unique: true, name: :index_unique_fitting_stock_level_items
    end
  end

  def down
    drop_table :fitting_stock_level_items
    drop_table :fitting_stock_levels

    execute 'DROP TYPE fitting_stock_level_interval;'
  end
end
