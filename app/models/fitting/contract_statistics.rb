class Fitting < ApplicationRecord
  module ContractStatistics
    extend ActiveSupport::Concern

    included do
      has_many :contract_fittings, inverse_of: :fitting, dependent: :destroy

      has_many :contracts, through: :contract_fittings do
        def matching
          where('contract_fittings.quantity > 0')
        end

        def partially_matching
          where('contract_fittings.similarity >= 0.95 AND contract_fittings.similarity < 1.0')
        end

        def problematic
          where('contract_fittings.similarity >= 0.75 AND contract_fittings.similarity < 1.0')
        end

        def all_matching
          where('contract_fittings.similarity >= 0.75')
        end
      end
    end

    def contracts_on_hand
      contracts.where(id: contract_fittings.matching.outstanding.pluck(:contract_id))
    end

    def contracts_all_on_hand
      contracts.all_matching.outstanding
    end

    def contracts_received(period = nil)
      contracts.where(id: contract_fittings.matching.pluck(:contract_id), issued_at: build_period(period))
    end

    def contracts_sold(period = nil)
      contracts.finished.where(
        id: contract_fittings.matching.pluck(:contract_id),
        completed_at: build_period(period)
      )
    end

    def contracts_sold_daily_avg(period = nil)
      range = build_period(period)
      days = (range.first.to_date...range.last.to_date).count
      contracts_sold(period).group_by_day(:completed_at).count.values.sum / days.to_d
    end

    def contracts_sell_through_rate(period = nil)
      (contracts_sold(build_period(period)).count.to_d / contracts_received(build_period(period)).count.to_d) * 100.0
    end

    def contract_quality
      return unless contracts.outstanding.count.positive?

      (contracts.matching.outstanding.count.to_d / contracts.outstanding.count.to_d) * 100.0
    end

    def match_contract(contract)
      MatchContract.call(self, contract)
    end
  end
end
