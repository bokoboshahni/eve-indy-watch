# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class FetchFromESIWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(location_type, location_id)
      location = Object.const_get(location_type).find(location_id)
      expires, last_modified, responses = location.fetch_market_orders

      if responses&.count&.positive?
        args = responses.map { |data| [location_type, location_id, expires, last_modified, data] }
        Sidekiq::Client.push_bulk('class' => 'MarketOrderSnapshot::ImportFromESIWorker', 'args' => args)
      end

      location.update!(
        esi_market_orders_expires_at: expires,
        esi_market_orders_last_modified_at: last_modified
      )
    end
  end
end
