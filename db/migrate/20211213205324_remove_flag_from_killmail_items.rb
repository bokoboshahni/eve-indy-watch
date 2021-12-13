class RemoveFlagFromKillmailItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :killmail_items, :flag, :text
  end
end
