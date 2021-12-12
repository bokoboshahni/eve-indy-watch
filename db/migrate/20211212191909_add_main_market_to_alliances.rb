class AddMainMarketToAlliances < ActiveRecord::Migration[6.1]
  def change
    add_reference :alliances, :main_market, foreign_key: { to_table: :markets }
  end
end
