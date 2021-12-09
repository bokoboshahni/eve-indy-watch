# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncAllContractsFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: { client: :log, server: :reject }

    def perform
      Corporation.where(contract_sync_enabled: true).where('esi_contracts_expires_at <= ?', Time.zone.now)
                 .or(Corporation.where(contract_sync_enabled: true, esi_contracts_last_modified_at: nil))
                 .each(&:fetch_contracts_from_esi_async)
    end
  end
end
