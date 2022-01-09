class Market < ApplicationRecord
  class IngestAllWorker < ApplicationWorker
    sidekiq_options retries: 3, lock: :until_executed

    def perform
      args = Market.active.where.not(source_location_id: nil)
                   .distinct(:source_location_id)
                   .pluck(:source_location_id)
                   .map { |id| [id] }
      Location::SnapshotOrdersFromESIWorker.perform_bulk(args)
    end
  end
end
