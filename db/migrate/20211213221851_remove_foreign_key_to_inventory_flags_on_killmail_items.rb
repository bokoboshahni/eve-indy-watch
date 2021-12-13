class RemoveForeignKeyToInventoryFlagsOnKillmailItems < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :killmail_items, :inventory_flags, column: :flag_id
  end
end
