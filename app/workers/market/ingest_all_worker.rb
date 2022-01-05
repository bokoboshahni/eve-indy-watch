class Market < ApplicationRecord
  class IngestAllWorker < ApplicationWorker
    sidekiq_options retries: 3, lock: :until_executed

    def perform
      args = MarketLocation.pluck(:source_location_id).uniq.map { |id| [id] }
      Location::SnapshotOrdersFromESIWorker.perform_bulk(args)
    end
  end
end
