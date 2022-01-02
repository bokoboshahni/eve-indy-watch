class Order < StatisticsRecord
  class FetchAllFromESIWorker < ApplicationWorker
    sidekiq_options retries: 5, lock: :until_executed

    def perform
      locations = Structure.select(:id).where(market_order_sync_enabled: true)
      locations += Region.select(:id).where(market_order_sync_enabled: true)
      args = locations.map { |l| [l.id] }
      FetchAllFromESI.perform_bulk(args)
    end
  end
end
