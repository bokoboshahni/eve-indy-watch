class RemoveCharCorpAllianceForeignKeysFromKillmails < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :killmails, :characters
    remove_foreign_key :killmails, :corporations
    remove_foreign_key :killmails, :alliances

    remove_foreign_key :killmail_attackers, :characters
    remove_foreign_key :killmail_attackers, :corporations
    remove_foreign_key :killmail_attackers, :alliances
  end
end
