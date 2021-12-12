class AddAppraisalMarketToAlliances < ActiveRecord::Migration[6.1]
  def change
    add_reference :alliances, :appraisal_market, foreign_key: { to_table: :markets }
  end
end
