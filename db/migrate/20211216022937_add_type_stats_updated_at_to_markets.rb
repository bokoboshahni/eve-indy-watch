class AddTypeStatsUpdatedAtToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :type_stats_updated_at, :datetime
  end
end
