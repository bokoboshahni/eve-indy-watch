# frozen_string_literal: true

class Contract < ApplicationRecord
  class SyncItemsFromESIWorker < ApplicationWorker
    sidekiq_options queue: :contracts, lock: :until_executed, lock_ttl: 5.minutes
    sidekiq_throttle threshold: { limit: 20, period: 10.seconds }

    def perform(contract_id)
      contract = Contract.find(contract_id)

      return if contract.status == 'deleted'

      contract.sync_items_from_esi!
      contract.discover_fittings!
    rescue ActiveRecord::RecordNotFound
      debug "Contract #{contract_id} no longer exists"
    end
  end
end
