class MarketOrder < ApplicationRecord
  class CompressBatch < ApplicationService
    def initialize(batch)
      super

      @batch = batch
    end

    def call
      batch_path = Rails.root.join("tmp/market_orders/#{batch.id}")
      batch_files = Dir["#{batch_path}/*.json"]
      gzip_path = Rails.root.join("tmp/market_orders/#{batch.time.strftime("%Y%m%dT%H%M")}_market_order_batch_#{batch.id}.json.gz")

      system("cat #{batch_files.join(' ')} | gzip > #{gzip_path}")
      FileUtils.rm_rf(batch_path)

      batch.update!(compressed_at: Time.zone.now)
    end

    private

    attr_reader :batch
  end
end
