# frozen_string_literal: true

class Contract < ApplicationRecord
  class DiscoverFittings < ApplicationService
    def initialize(contract)
      super

      @contract = contract
    end

    def call
      ship_ids = contract.items.joins(type: :group).where(groups: { category_id: SHIP_CATEGORY_ID }).pluck(:type_id)
      candidates = Fitting.includes(:items).where(type_id: ship_ids)
      contract.transaction do
        matches = candidates.map do |fitting|
          match_info = Fitting::MatchContract.call(fitting, contract)

          cf = contract.contract_fittings.find_or_initialize_by(fitting_id: fitting.id)
          cf.attributes = cf.attributes.merge(match_info)
          cf.save!
        end

        debug "Scored #{matches.count} fitting(s) for contract #{contract.id}"
      end
    end

    private

    SHIP_CATEGORY_ID = 6

    attr_reader :contract
  end
end
