class Contract < ApplicationRecord
  class SyncFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

    def perform(corporation_id, json)
      corporation = Corporation.find(corporation_id)
      data = Oj.load(json)

      contract = Contract::SyncFromESI.call(corporation, data)
      contract.sync_items_from_esi_async
    end
  end
end
