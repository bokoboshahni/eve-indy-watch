# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class SyncLocationOrdersFromESIWorker < ApplicationWorker
    class Callback
      def on_complete(status, options)
        location = Object.const_get(options['location_class']).find(options['location_id'])
        expires = DateTime.parse(options['expires'])
        last_modified = DateTime.parse(options['last_modified'])

        return if location.esi_market_orders_last_modified_at > last_modified

        location.update!(esi_market_orders_last_modified_at: last_modified, esi_market_orders_expires_at: expires)
      end
    end

    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

    def perform(location_class_name, location_id)
      location_class = Object.const_get(location_class_name)
      location = location_class.find(location_id)

      unless location.esi_market_orders_expired?
        debug("ESI response for market orders at #{location.name} (#{location.id}) is not expired: #{location.esi_market_orders_expires_at.iso8601}")
        return
      end

      responses, last_modified, expires = MarketOrderSnapshot::FetchLocationFromESI.call(location)

      return unless responses.count.positive?

      batch = Sidekiq::Batch.new
      batch.on(:complete, Callback, location_class: location_class_name, location_id: location_id, last_modified: last_modified, expires: expires)
      args = responses.map { |data| [location_class_name, location_id, last_modified, expires, data] }
      Sidekiq::Client.push_bulk('class' => 'MarketOrderSnapshot::ProcessESIResponseWorker', 'args' => args)
    end
  end
end
