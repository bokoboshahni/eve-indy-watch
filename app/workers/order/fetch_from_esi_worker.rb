class Order < StatisticsRecord
  class FetchFromESIWorker < ApplicationWorker
    sidekiq_options retries: 5, lock: :until_executed

    def perform(location_id)
      time =
        if (10_000_000..11_000_000) === location_id
          Order::FetchFromESI.call(Region.find(location_id))
        else
          Order::FetchFromESI.call(Structure.find(location_id))
        end

      Order::Compress.call(location_id, time, delete: !Rails.env.development?) if time
    end
  end
end
