# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class FetchFromESIWorker < ApplicationWorker
    class Callback
      def on_success(status, options)
        location = Object.const_get(options['location_type']).find(options['location_id'])
        time = options['time']

        location_ids =
          case location
          when Region
            location.stations.pluck(:id)
          when Structure
            [location.id]
          end


        Market.joins(:market_locations)
              .where("market_locations.location_id IN (?)", location_ids)
              .each { |m| m.create_stats_async(time) }
      end
    end

    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(location_type, location_id)
      location = Object.const_get(location_type).find(location_id)
      expires, last_modified, responses = location.fetch_market_orders

      if responses&.count&.positive?
        batch = Sidekiq::Batch.new
        batch.on(:success, Callback, location_type: location_type, location_id: location_id, time: last_modified)
        batch.jobs do
          args = responses.map { |data| [location_type, location_id, expires, last_modified, data] }
          Sidekiq::Client.push_bulk('class' => 'MarketOrderSnapshot::ImportFromESIWorker', 'args' => args)
        end
      end

      location.update!(
        esi_market_orders_expires_at: expires,
        esi_market_orders_last_modified_at: last_modified
      )
    end
  end
end
