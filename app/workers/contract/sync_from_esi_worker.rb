# frozen_string_literal: true

class Contract < ApplicationRecord
  class SyncFromESIWorker < ApplicationWorker
    sidekiq_options queue: :contracts, lock: :until_executed, lock_ttl: 5.minutes

    def perform(corporation_id, json)
      corporation = Corporation.find(corporation_id)
      data = Oj.load(json)

      contract = Contract::SyncFromESI.call(corporation, data)

      return if contract.status == 'deleted'

      contract.sync_items_from_esi_async
    end
  end
end
