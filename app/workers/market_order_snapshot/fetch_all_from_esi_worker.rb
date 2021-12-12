# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class FetchAllFromESIWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform
      [
        Structure.where(market_order_sync_enabled: true),
        Region.where(market_order_sync_enabled: true)
      ].flatten.each do |location|
        location.fetch_market_orders_async
      end
    end
  end
end
