class Contract < ApplicationRecord
  class DiscoverFittingsWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(contract_id)
      contract = Contract.find(contract_id)
      contract.discover_fittings!
    end
  end
end
