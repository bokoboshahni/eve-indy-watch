class ChangeMarketTypesChunkIntervalTo24h < ActiveRecord::Migration[6.1]
  def up
    execute "SELECT set_chunk_time_interval('market_types', INTERVAL '24 hours');"
  end

  def down
    execute "SELECT set_chunk_time_interval('market_types', INTERVAL '7 days');"
  end
end
