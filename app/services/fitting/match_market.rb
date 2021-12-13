# frozen_string_literal: true

class Fitting < ApplicationRecord
  class MatchMarket < ApplicationService
    def initialize(fitting, market)
      super

      @fitting = fitting
      @market = market
    end

    def call
      debug "Fitting items: #{fitting_item_ids.sort}"
      debug "Market items: #{market_item_ids.sort}"
      debug "Missing items: #{fitting_item_ids - market_item_ids}"
      missing_items = fitting_item_ids - market_item_ids

      match_items = fitting_items.each_with_object({}) do |(fit_item, fit_qty), h|
        market_qty = market_items.fetch(fit_item, 0)
        h[fit_item] = market_qty / fit_qty
      end

      match_quantities = match_items.values
      full_matches = match_quantities.uniq.each_with_object([]) do |n, a|
        a << n if match_quantities.all? { |q| q >= n }
      end

      {
        items: match_items,
        quantity: full_matches.max
      }
    end

    private

    attr_reader :fitting, :market

    delegate :id, to: :market, prefix: true

    def fitting_items
      @fitting_items ||= fitting.compact_items
    end

    def fitting_item_ids
      fitting_items.keys
    end

    def market_items
      @market_items ||=
        begin
          ids = market_item_ids.select { |id| fitting_item_ids.include?(id) }
          types = Type.find(ids)
          types.each_with_object({}) { |t, h| h[t.id] = t.market_volume(market) }
        end
    end

    def market_item_ids
      @market_item_ids ||= market.type_ids_for_sale
    end
  end
end
