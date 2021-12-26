class MarketOrder < ApplicationRecord
  class Prune < ApplicationService
    def initialize(before)
      super

      @before = before
    end

    def call
      MarketOrder.transaction do
        MarketOrder.where('time < ?', before).delete_all
      end
    end

    private

    attr_reader :before
  end
end
