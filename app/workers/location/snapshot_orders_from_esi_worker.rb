# frozen_string_literal: true

class Location < ApplicationRecord
  class SnapshotOrdersFromESIWorker < ApplicationWorker
    sidekiq_options retries: 3, lock: :until_executed

    def perform(location_id) # rubocop:disable Metrics/MethodLength
      time =
        if (10_000_000..11_000_000).cover?(location_id)
          Location::SnapshotOrdersFromESI.call(Region.find(location_id))
        else
          Location::SnapshotOrdersFromESI.call(Structure.find(location_id))
        end

      unless time
        debug("No orders found for #{location_id}")
        return
      end

      location = Location.find(location_id)
      location.markets.each do |market|
        unless market.active?
          debug("Market #{market.log_name} is not active")
          next
        end

        unless market.orders_last_modified.to_i >= time.to_i
          debug("Market statistics have already been generated for #{log_name} at #{time.to_s(:db)}")
          next
        end

        market.calculate_type_statistics_async(time)
      end
    end
  end
end
