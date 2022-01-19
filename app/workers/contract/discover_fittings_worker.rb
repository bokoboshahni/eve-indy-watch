# frozen_string_literal: true

class Contract < ApplicationRecord
  class DiscoverFittingsWorker < ApplicationWorker
    sidekiq_options queue: :contracts, lock: :until_executed, lock_ttl: 5.minutes

    def perform(contract_id)
      contract = Contract.find(contract_id)
      contract.discover_fittings!
    end
  end
end
