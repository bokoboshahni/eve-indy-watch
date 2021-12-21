class MarketOrder < ApplicationRecord
  class CompleteBatchWorker < ApplicationWorker
    def perform(batch_id)
      batch = Batch.find(batch_id)
      batch.complete!
    end
  end
end
