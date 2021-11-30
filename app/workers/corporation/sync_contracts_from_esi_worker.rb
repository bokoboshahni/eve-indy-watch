# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncContractsFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

    def perform(corporation_id)
      corporation = Corporation.find(corporation_id)
      contracts = corporation.sync_contracts_from_esi!

      item_contracts = contracts.select(&:esi_items_unsynced?)

      return unless item_contracts.count.positive?

      args = item_contracts.map { |c| [c.id, c.issuer_id] }
      Sidekiq::Client.push_bulk('class' => 'Contract::SyncItemsFromESIWorker', 'args' => args)
    end
  end
end
