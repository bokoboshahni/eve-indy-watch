class DisableTimescaledb < ActiveRecord::Migration[6.1]
  def change
    disable_extension 'timescaledb'
  end
end
