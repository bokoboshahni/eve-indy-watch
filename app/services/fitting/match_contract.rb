class Fitting < ApplicationRecord
  class MatchContract < ApplicationService
    def initialize(fitting, contract)
      super

      @fitting = fitting
      @contract = contract
    end

    def call
      debug "Fitting items: #{fitting_item_ids.sort}"
      debug "Contract items: #{contract_item_ids.sort}"
      debug "Missing items: #{fitting_item_ids - contract_item_ids}"

      return 0 unless (fitting_item_ids - contract_item_ids).empty?

      match_items = fitting_items.each_with_object({}) do |(fit_item, fit_qty), h|
        h[fit_item] = fit_qty / contract_items[fit_item]
      end

      debug(match_items)

      match_quantities = match_items.values
      full_matches = match_quantities.uniq.each_with_object([]) do |n, a|
        a << n if match_quantities.all? { |q| q >= n }
      end

      full_matches.max
    end

    private

    attr_reader :fitting, :contract

    delegate :id, to: :contract, prefix: true

    def fitting_items
      fitting.compact_items
    end

    def fitting_item_ids
      fitting_items.keys
    end

    def contract_items
      contract.compact_items
    end

    def contract_item_ids
      contract_items.keys
    end
  end
end
