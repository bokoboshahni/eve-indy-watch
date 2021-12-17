class MarketOrder < ApplicationRecord
  class CompleteBatchWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(batch_id)
      batch = Batch.find(batch_id)

      return if batch.completed?

      batch.complete!
    end
  end
end
