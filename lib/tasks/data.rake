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

  task migrate_fitting_stock_levels: :environment do
    interval_map = {
      'daily' => :end_of_day,
      'weekly' => :end_of_week,
      'monthly' => :end_of_month
    }

    Statistics::FittingStockLevelSummary.in_batches do |originals|
      items = []
      levels = originals.each_with_object([]) do |original, a|
        migrated = original.attributes
        migrated['interval'] = interval_map[original['interval']]

        original.items.map(&:attributes).each do |ir|
          ir['interval'] = interval_map[ir['interval']]
          items << ir
        end

        a << migrated
      end

      FittingStockLevel.transaction do
        FittingStockLevel.upsert_all(levels, unique_by: :index_unique_fitting_stock_levels)
        FittingStockLevelItem.upsert_all(items, unique_by: :index_unique_fitting_stock_level_items)
      end

      Rails.logger.info("Migrated #{levels.count} stock levels and #{items.count} stock level items")
    end
  end
end
