class AddFlagIDToKillmailItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :killmail_items, :flag, foreign_key: { to_table: :inventory_flags }
  end
end
