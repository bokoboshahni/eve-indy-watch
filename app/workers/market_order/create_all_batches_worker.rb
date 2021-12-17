class MarketOrder < ApplicationRecord
  class CreateAllBatchesWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform
      locations = Structure.select(:id).where(market_order_sync_enabled: true)
      locations += Region.select(:id).where(market_order_sync_enabled: true)
      args = locations.map { |l| [l.class.name, l.id] }
      MarketOrder::CreateBatchWorker.perform_bulk(args)
    end
  end
end
