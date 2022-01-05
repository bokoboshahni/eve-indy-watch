class Location < ApplicationRecord
  class SnapshotOrdersFromESIWorker < ApplicationWorker
    sidekiq_options retries: 3, lock: :until_executed

    def perform(location_id)
      time =
        if (10_000_000..11_000_000) === location_id
          Location::SnapshotOrdersFromESI.call(Region.find(location_id))
        else
          Location::SnapshotOrdersFromESI.call(Structure.find(location_id))
        end

      unless time
        debug("No orders found for #{location_id}")
        return
      end

      location = Location.find(location_id)
      args = location.markets.pluck(:id).map { |market_id| [market_id, time.to_s(:number)] }
      Market::CalculateDepthWorker.perform_bulk(args)
    end
  end
end
