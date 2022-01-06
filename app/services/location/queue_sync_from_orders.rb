class Location < ApplicationRecord
  class QueueSyncFromOrders < ApplicationService
    def initialize(source_location, time)
      super

      @source_location = source_location
      @time = time
    end

    def call
      now = Time.zone.now.to_i
      location_ids_key = "orders.#{source_location_id}.#{time.to_s(:number)}.location_ids"
      location_ids = orders_reader.smembers(location_ids_key).reject do |id|
        locations_reader.get("locations.#{id}.esi_expires").to_i > now.to_i
      end

      args = location_ids.map { |l| [l, esi_authorization_id] }
      Location::ResolveAndSyncWorker.perform_bulk(args)
    end

    private

    attr_reader :source_location, :time

    delegate :id, to: :source_location, prefix: true
    delegate :esi_authorization_id, to: :source_location
  end
end
