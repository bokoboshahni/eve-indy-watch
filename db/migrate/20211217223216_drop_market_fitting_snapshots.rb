class DropMarketFittingSnapshots < ActiveRecord::Migration[6.1]
  def change
    drop_table :market_fitting_snapshots
  end
end
