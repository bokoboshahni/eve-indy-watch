# frozen_string_literal: true

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

      match_items = fitting_items.each_with_object({}) do |(fit_item, fit_qty), h|
        contract_qty = contract_items.fetch(fit_item, 0)
        h[fit_item] = contract_qty.zero? ? 0 : fit_qty / contract_qty
      end

      similarity = match_items.values.select(&:positive?).count.to_d / match_items.count.to_d

      match_quantities = match_items.values
      full_matches = match_quantities.uniq.each_with_object([]) do |n, a|
        a << n if match_quantities.all? { |q| q >= n }
      end

      full_matches.max

      {
        items: match_items,
        quantity: full_matches.max,
        similarity: similarity
      }
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
