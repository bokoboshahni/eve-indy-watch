class AddMatchThresholdsToFittings < ActiveRecord::Migration[6.1]
  def change
    add_column :fittings, :contract_match_threshold, :decimal
    add_column :fittings, :killmail_match_threshold, :decimal
  end
end
