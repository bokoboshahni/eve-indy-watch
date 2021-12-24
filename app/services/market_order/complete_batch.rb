class MarketOrder < ApplicationRecord
  class CompleteBatch < ApplicationService
    def initialize(batch)
      super

      @batch = batch
    end

    def call
      batch.transaction do
        batch.lock!

        if batch.completed?
          debug("Market order batch #{batch.id} for #{location.log_name} has already been processed")
          return
        end

        unless batch.pages.all? { |p| p.imported? }
          debug("Market order batch #{batch.id} for #{location.log_name} is not fully imported")
          return
        end

        if location.orders_updated_at.nil? || (location.orders_updated_at && location.orders_updated_at <= time)
          location.update!(orders_updated_at: time)
        end

        location_ids = MarketOrder.distinct(:location_id).where(time: time).pluck(:location_id)
        location_ids += [location.id] if location.is_a?(Region)
        markets = Market.joins(:market_locations).where("market_locations.location_id IN (?)", location_ids)
        markets = markets.where(private: [false, nil]) if location.is_a?(Region)
        alliance_market_ids = Alliance.pluck(:main_market_id, :appraisal_market_id).flatten.compact.uniq
        markets.each do |market|
          if batch.location_type == 'Region' && market.private?
            error "Cannot aggregate type or fitting statistics from regional batch #{batch.id} for private market #{market.log_name}"
            next
          end

          if market.orders_updated_at.nil? || (market.orders_updated_at && market.orders_updated_at <= time)
            market.update!(orders_updated_at: time)
          end

          market.aggregate_type_stats!(time, batch)
        end

        batch.update!(completed_at: Time.zone.now)
      end

      batch
    rescue ActiveRecord::Deadlocked
      warn("Market order batch #{batch.id} for #{location.log_name} is currently being processed.")
    end

    private

    attr_reader :batch, :markets

    delegate :location, :time, to: :batch
  end
end
