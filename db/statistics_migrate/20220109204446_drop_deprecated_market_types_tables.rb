# frozen_string_literal: true

class DropDeprecatedMarketTypesTables < ActiveRecord::Migration[6.1]
  def up
    execute 'DROP MATERIALIZED VIEW market_type_daily_summaries CASCADE;'
    drop_table :market_types
  end
end
