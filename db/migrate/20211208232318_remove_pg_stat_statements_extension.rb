class RemovePgStatStatementsExtension < ActiveRecord::Migration[6.1]
  def change
    disable_extension 'pg_stat_statements'
  end
end
