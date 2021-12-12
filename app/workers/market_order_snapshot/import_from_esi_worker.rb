# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class ImportFromESIWorker < ApplicationWorker
    def perform(location_type, location_id, expires, last_modified, data)
      location = Object.const_get(location_type).find(location_id)
      last_modified = DateTime.parse(last_modified)
      expires = DateTime.parse(expires)
      data = Oj.load(data)

      order_locations = data.each_with_object(Set.new) { |o, s| s.add(o['location_id']) }
      order_location_args = order_locations.to_a.map { |l| [l, location.esi_authorization_id] }
      Sidekiq::Client.push_bulk('class' => 'ResolveAndSyncLocationWorker', 'args' => order_location_args)

      MarketOrderSnapshot.import_from_esi!(location, expires, last_modified, data)
    end
  end
end
