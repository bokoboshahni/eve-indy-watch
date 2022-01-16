# frozen_string_literal: true

class CreateRegionTypeHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :region_type_histories, id: false, primary_key: %i[region_id type_id date] do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :region, null: false
      t.references :type, null: false
      t.date :date, null: false

      t.decimal :average
      t.decimal :highest
      t.decimal :lowest
      t.bigint :order_count
      t.bigint :volume

      t.index %i[region_id type_id date], unique: true, name: :index_unique_region_type_histories
    end
  end
end
