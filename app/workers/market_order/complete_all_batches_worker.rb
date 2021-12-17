class MarketOrder < ApplicationRecord
  class CompleteAllBatchesWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform
      args = Batch.where(completed_at: nil).pluck(:id).map { |id| [id] }
      MarketOrder::CompleteBatchWorker.perform_bulk(args)
    end
  end
end
