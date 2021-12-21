class AddMarketTypeIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :market_types, %i[market_id type_id time], order: { time: :desc }
  end
end
