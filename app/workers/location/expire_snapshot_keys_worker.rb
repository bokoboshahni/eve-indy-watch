class Location < ApplicationRecord
  class ExpireSnapshotKeysWorker < ApplicationWorker
    def perform
      orders_writer.scan_each(match: 'orders.*').to_a
    end
  end
end
