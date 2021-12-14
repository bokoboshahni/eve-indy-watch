class MarketOrderSnapshot < ApplicationRecord
  class Prune < ApplicationService
    def initialize(before)
      super

      @before = before
    end

    def call
      MarketOrderSnapshot.where('esi_last_modified_at < ?', before).delete_all
    end

    private

    attr_reader :before
  end
end
