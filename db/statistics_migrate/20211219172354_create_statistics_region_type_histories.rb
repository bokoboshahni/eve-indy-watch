class CreateStatisticsRegionTypeHistories < ActiveRecord::Migration[6.1]
  def up
    create_table :region_type_histories, id: false, primary_key: %i[region_id type_id date] do |t|
      t.bigint :region_id, null: false
      t.bigint :type_id, null: false
      t.date :date, null: false

      t.decimal :average, null: false
      t.decimal :highest, null: false
      t.decimal :lowest, null: false
      t.bigint :order_count, null: false
      t.bigint :volume, null: false

      t.index %i[region_id type_id date], unique: true, name: :index_unique_region_type_histories
    end

    execute "SELECT create_hypertable('region_type_histories', 'date');"

    execute "SELECT add_retention_policy('region_type_histories', interval '5 years');"
  end

  def down
    drop_table :region_type_histories
  end
end
