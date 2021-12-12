# frozen_string_literal: true

class MarketFittingSnapshot < ApplicationRecord
  class CreateForAllFittingsAndMarkets < ApplicationWorker
    def perform
      time = Time.zone.now
      Market.all.each do |market|
        Fitting.all.each do |fitting|
          MarketFittingSnapshot::CreateFromFittingAndMarketWorker.perform_async(market.id, fitting.id, time)
        end
      end
    end
  end
end
