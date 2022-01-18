# frozen_string_literal: true

class AddUnconfirmedToProcurementOrderStatus < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    execute <<-SQL.squish
      ALTER TYPE procurement_order_status ADD VALUE 'unconfirmed' AFTER 'in_progress';
    SQL
  end
end
