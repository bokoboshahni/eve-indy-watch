class MarketOrder < ApplicationRecord
  class CompleteBatchWorker < ApplicationWorker
    sidekiq_throttle concurrency: { limit: 1, key_suffix: -> batch_id { batch_id } },
                     threshold: { limit: 1, period: 5.minutes, key_suffix: -> batch_d { batch_id } }

    def perform(batch_id)
      batch = Batch.find(batch_id)
      batch.complete!
    end
  end
end
