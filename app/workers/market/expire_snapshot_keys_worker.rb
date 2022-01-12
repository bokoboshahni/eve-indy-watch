class Market < ApplicationRecord
  class ExpireSnapshotKeysWorker < ApplicationWorker
    def perform
      markets_writer.scan_each(match: 'markets.*').to_a
    end
  end
end
