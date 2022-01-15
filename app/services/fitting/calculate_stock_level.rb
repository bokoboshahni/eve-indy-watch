# frozen_string_literal: true

class Fitting < ApplicationRecord
  class CalculateStockLevel < ApplicationService
    def initialize(fitting_id, market_id, market_time, time, interval)
      super

      @fitting = Fitting.eager_load(:items).find(fitting_id)
      @fitting_market = FittingMarket.find([fitting_id, market_id])
      @market = Market.find(market_id)
      @market_time = market_time
      @time = time
      @interval = interval.to_sym
    end

    def call
      @time = time.prev_day.beginning_of_day unless interval == :live

      stock_level = {
        market_id: market_id,
        time: time,
        market_time: market_time,
        interval: interval
      }

      stock_level.merge!(contract_stock_level) if contract_stock_level_enabled?
      stock_level.merge!(market_stock_level) if market_stock_level_enabled?

      fitting.stock_levels.create!(stock_level)
    rescue ActiveRecord::RecordNotUnique
      error(
        "Stock level record already exists for #{fitting.log_name} in #{market.log_name} at #{time} and market " \
        "time #{market_time} for '#{interval} interval"
      )
    end

    private

    attr_reader :fitting, :market, :market_time, :time, :interval, :fitting_market

    delegate :compact_items, to: :fitting
    delegate :id, to: :fitting, prefix: true

    delegate :id, to: :market, prefix: true

    delegate :contract_stock_level_enabled?, :market_stock_level_enabled?, to: :fitting_market

    def location_ids
      @location_ids ||= markets_reader.smembers("markets.#{market_id}.location_ids").map(&:to_i)
    end

    def contract_stock_level
      {
        contract_price_avg: contracts_on_hand.average(:price),
        contract_price_med: contracts_on_hand.median(:price),
        contract_price_min: contracts_on_hand.minimum(:price),
        contract_price_max: contracts_on_hand.maximum(:price),
        contract_price_sum: contracts_on_hand.sum(:price),
        contract_match_quantity: contracts_on_hand.count,
        contract_match_threshold: fitting.contract_match_threshold,
        contract_total_quantity: contracts.outstanding.count,
        contract_similarity_avg: contract_fittings.average(:similarity),
        contract_similarity_med: contract_fittings.median(:similarity),
        contract_similarity_min: contract_fittings.minimum(:similarity),
        contract_similarity_max: contract_fittings.maximum(:similarity)
      }
    end

    def market_stock_level # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      result = {}

      market_key = "markets.#{market_id}.#{market_time.to_s(:number)}"
      type_ids = compact_items.keys
      type_keys =  type_ids.map { |t| "#{market_key}.types.#{t}.stats" }
      market_stats = markets_reader.mapped_mget(*type_keys)
                                   .transform_keys! { |k| k.split('.')[-2].to_i }
                                   .transform_values! { |j| Oj.load(j) if j.present? }

      result[:items_attributes] = compact_items.each_with_object({}) do |(item_id, fitting_qty), h|
        stock_item = { fitting_id: fitting_id, market_id: market_id, type_id: item_id, interval: interval, time: time }
        market_item = market_stats[item_id]

        if market_item
          stock_item.merge!(
            fitting_quantity: market_item.dig(:sell, :volume_sum).to_i / fitting_qty,
            market_buy_price: market_item.dig(:buy, :price_max),
            market_sell_price: market_item.dig(:sell, :price_min),
            market_sell_volume: market_item.dig(:sell, :volume_sum).to_i
          )
        else
          stock_item[:fitting_quantity] = 0
          stock_item[:market_sell_volume] = 0
        end

        h[item_id] = stock_item
      end

      match_quantities = result[:items_attributes].values.pluck(:fitting_quantity)
      full_matches = match_quantities.uniq.each_with_object([]) do |n, a|
        a << n if match_quantities.all? { |q| q.to_i >= n.to_i }
      end

      result[:market_quantity] = full_matches.max || 0

      %i[market_buy_price market_sell_price].each do |stat|
        result[stat] = result[:items_attributes].values.filter_map { |i| i[stat] }.sum
      end

      result
    end

    def contracts
      fitting.contracts.at(location_ids)
    end

    def contracts_on_hand
      fitting.contracts_on_hand.at(location_ids)
    end

    def contract_fittings
      fitting.contract_fittings.joins(:contract).where(contracts: { end_location_id: location_ids })
    end
  end
end
