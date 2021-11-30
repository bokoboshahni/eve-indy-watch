# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncAllContractsFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: { client: :log, server: :reject }

    def perform
      Corporation.where(contract_sync_enabled: true).each(&:sync_contracts_from_esi_async)
    end
  end
end
