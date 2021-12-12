# frozen_string_literal: true

class Market < ApplicationRecord
  class AggregateTypesWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(market_id, aggregation, interval)
      market = Market.find(market_id)
      market.aggregate_types!(aggregation, interval)
    end
  end
end
