class MarketOrder < ApplicationRecord
  class CreateBatchWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(location_type, location_id)
      location = Object.const_get(location_type).find(location_id)
      batch = CreateBatch.call(location)

      return unless batch

      args = MarketOrder::Batch.find(batch.id).page_ids
      MarketOrder::ImportPageWorker.perform_bulk(args)
    end
  end
end
