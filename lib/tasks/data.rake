# frozen_string_literal: true

namespace :data do
  task backfill_market_location_sources: :environment do
    MarketLocation.find_each do |market_location|
      if market_location.location.is_a?(Region) || (market_location.location.is_a?(Structure) && market_location.market.private?)
        market_location.update(source_location: Location.find(market_location.location_id))
      elsif market_location.location.is_a?(Station) || market_location.location.is_a?(Structure)
        market_location.update(source_location: Location.find(market_location.location.region.id))
      end
    end
  end
end
