module Statistics
  class MarketFitting < ApplicationRecord
    self.primary_keys = :market_id, :fitting_id, :time

    validates :market_id, presence: true
    validates :fitting_id, presence: true
    validates :time, presence: true

    def limiting_items
      @limiting_items ||=
        begin
          ids = items.each_with_object([]) { |(i, q), a| a << i if q.zero? }
          ids.empty? ? [] : Type.find(ids)
        end
    end
  end
end
