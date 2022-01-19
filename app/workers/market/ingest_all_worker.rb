# frozen_string_literal: true

class Market < ApplicationRecord
  class IngestAllWorker < ApplicationWorker
    sidekiq_options queue: :markets, lock: :until_executed, locK_ttl: 5.minutes

    def perform
      args = Market.active.where.not(source_location_id: nil)
                   .distinct(:source_location_id)
                   .pluck(:source_location_id)
                   .map { |id| [id] }
      Location::SnapshotOrdersFromESIWorker.perform_bulk(args)
    end
  end
end
