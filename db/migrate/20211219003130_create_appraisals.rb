class CreateAppraisals < ActiveRecord::Migration[6.1]
  def change
    create_table :appraisals do |t|
      t.references :appraisable, polymorphic: true
      t.references :market, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.text :code, null: false, index: { unique: true }
      t.text :description
      t.decimal :price_modifier
      t.text :price_period, null: false
      t.text :price_stat, null: false
      t.text :price_type, null: false
      t.datetime :expires_at
      t.datetime :market_time, null: false
      t.text :original
      t.timestamps null: false
    end

    create_table :appraisal_items, id: false, primary_key: %i[appraisal_id type_id] do |t|
      t.references :appraisal, null: false
      t.references :type, null: false

      t.decimal :buy_five_pct_price_avg
      t.decimal :buy_five_pct_price_med
      t.bigint :buy_five_pct_order_count
      t.decimal :buy_price_avg
      t.decimal :buy_price_min
      t.decimal :buy_price_med
      t.decimal :buy_price_max
      t.decimal :buy_price_sum
      t.decimal :buy_volume_avg
      t.bigint :buy_volume_min
      t.bigint :buy_volume_med
      t.bigint :buy_volume_max
      t.bigint :buy_volume_sum
      t.bigint :buy_total_order_count
      t.bigint :buy_trimmed_order_count

      t.decimal :sell_five_pct_price_avg
      t.decimal :sell_five_pct_price_med
      t.decimal :sell_five_pct_order_count
      t.decimal :sell_price_avg
      t.decimal :sell_price_min
      t.decimal :sell_price_med
      t.decimal :sell_price_max
      t.decimal :sell_price_sum
      t.decimal :sell_volume_avg
      t.bigint :sell_volume_min
      t.bigint :sell_volume_med
      t.bigint :sell_volume_max
      t.bigint :sell_volume_sum
      t.bigint :sell_total_order_count
      t.bigint :sell_trimmed_order_count

      t.decimal :buy_sell_price_spread, null: false

      t.bigint :quantity, null: false
    end
  end
end
