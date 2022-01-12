# frozen_string_literal: true

class CreateStatisticsFittingStockLevels < ActiveRecord::Migration[6.1]
  def up
    create_table :fitting_stock_levels, id: false, primary_key: %i[fitting_id market_id time] do |t|
      t.references :fitting, null: false, index: false
      t.references :market, null: false, index: false
      t.timestamp :time, null: false

      t.decimal :contract_price_avg
      t.decimal :contract_price_med
      t.decimal :contract_price_min
      t.decimal :contract_price_max
      t.decimal :contract_price_sum
      t.integer :contract_match_quantity
      t.decimal :contract_match_threshold
      t.integer :contract_total_quantity
      t.decimal :contract_similarity_avg
      t.decimal :contract_similarity_med
      t.decimal :contract_similarity_min
      t.decimal :contract_similarity_max
      t.decimal :market_buy_price
      t.decimal :market_sell_price
      t.integer :market_quantity
      t.timestamp :market_time

      t.index %i[fitting_id market_id time], unique: true, name: :index_unique_fitting_stock_levels,
                                             order: { time: :desc }
    end

    execute "SELECT create_hypertable('fitting_stock_levels', 'time', chunk_time_interval => INTERVAL '7 days');"

    execute "SELECT add_retention_policy('fitting_stock_levels', INTERVAL '7 days');"

    create_table :fitting_stock_level_items, id: false, primary_key: %i[fitting_id market_id type_id time] do |t|
      t.references :fitting, null: false, index: false
      t.references :market, null: false, index: false
      t.references :type, null: false, index: false
      t.timestamp :time, null: false

      t.integer :fitting_quantity, null: false
      t.decimal :market_buy_price
      t.decimal :market_sell_price
      t.integer :market_sell_volume, null: false

      t.index %i[fitting_id market_id type_id time], unique: true, name: :index_unique_fitting_stock_level_items,
                                                     order: { time: :desc }
    end

    execute "SELECT create_hypertable('fitting_stock_level_items', 'time', chunk_time_interval => INTERVAL '7 days');"

    execute "SELECT add_retention_policy('fitting_stock_level_items', INTERVAL '7 days');"

    create_table :fitting_stock_level_summaries, id: false, primary_key: %i[fitting_id market_id time interval] do |t|
      t.references :fitting, null: false, index: false
      t.references :market, null: false, index: false
      t.timestamp :time, null: false
      t.text :interval, null: false

      t.decimal :contract_price_avg
      t.decimal :contract_price_med
      t.decimal :contract_price_min
      t.decimal :contract_price_max
      t.decimal :contract_price_sum
      t.integer :contract_match_quantity
      t.decimal :contract_match_threshold
      t.integer :contract_total_quantity
      t.decimal :contract_similarity_avg
      t.decimal :contract_similarity_med
      t.decimal :contract_similarity_min
      t.decimal :contract_similarity_max
      t.decimal :market_buy_price
      t.decimal :market_sell_price
      t.integer :market_quantity
      t.timestamp :market_time

      t.index %i[fitting_id market_id time interval], unique: true, name: :index_unique_fitting_stock_level_summaries,
                                                      order: { time: :desc }
    end

    execute "SELECT create_hypertable('fitting_stock_level_summaries', 'time', chunk_time_interval => INTERVAL '1 month');"

    execute "SELECT add_retention_policy('fitting_stock_level_summaries', INTERVAL '5 years');"

    create_table :fitting_stock_level_summary_items, id: false,
                                                     primary_key: %i[fitting_id market_id type_id time interval] do |t|
      t.references :fitting, null: false, index: false
      t.references :market, null: false, index: false
      t.references :type, null: false, index: false
      t.timestamp :time, null: false
      t.text :interval, null: false

      t.integer :fitting_quantity, null: false
      t.decimal :market_buy_price
      t.decimal :market_sell_price
      t.integer :market_sell_volume, null: false

      t.index %i[fitting_id market_id type_id time interval], unique: true,
                                                              name: :index_unique_fitting_stock_level_summary_items, order: { time: :desc }
    end

    execute "SELECT create_hypertable('fitting_stock_level_summary_items', 'time', chunk_time_interval => INTERVAL '1 month');"

    execute "SELECT add_retention_policy('fitting_stock_level_summary_items', INTERVAL '5 years');"
  end

  def down
    drop_table :fitting_stock_level_summary_items
    drop_table :fitting_stock_level_summaries
    drop_table :fitting_stock_level_items
    drop_table :fitting_stock_levels
  end
end
