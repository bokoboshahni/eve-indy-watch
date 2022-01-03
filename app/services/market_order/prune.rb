class MarketOrder < ApplicationRecord
  class Prune < ApplicationService
    def initialize(before)
      super

      @before = before
    end

    def call
      MarketOrder.transaction do
        MarketOrder.where('time < ?', before).delete_all
        MarketOrder::Batch.where('time < ?', before).pluck(:id).each do |batch_id|
          batch_path = Rails.root.join("tmp/market_orders/#{batch_id}")
          FileUtils.rm_rf(batch_path)
        end
      end
    end

    private

    attr_reader :before
  end
end
