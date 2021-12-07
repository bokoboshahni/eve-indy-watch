# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class ProcessESIResponseWorker < ApplicationWorker
    sidekiq_options retry: 5

    def perform(location_class_name, location_id, last_modified, expires, data)
      location = Object.const_get(location_class_name).find(location_id)
      last_modified = DateTime.parse(last_modified)
      expires = DateTime.parse(expires)
      data = Oj.load(data)

      order_locations = data.each_with_object(Set.new) { |o, s| s.add(o['location_id']) }
      order_location_args = order_locations.to_a.map { |l| [l, location.esi_authorization_id] }
      Sidekiq::Client.push_bulk('class' => 'ResolveAndSyncLocationWorker', 'args' => order_location_args)

      MarketOrderSnapshot::ProcessESIResponse.call(location, last_modified, expires, data)
    end
  end
end
