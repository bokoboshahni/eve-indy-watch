# frozen_string_literal: true

class Appraisal < ApplicationRecord
  class GenerateItems < ApplicationService
    def initialize(items, market, time)
      super

      @items = items
      @market = market
      @time = time
    end

    def call
      items.each_with_object([]) do |(type_id, qty), a|
        a << stats.fetch(type_id, {}).merge(quantity: qty)
      end
    end

    private

    attr_reader :items, :market, :time

    delegate :id, to: :market, prefix: true

    def stats # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @stats ||=
        begin
          market_key = "markets.#{market_id}.#{time.to_formatted_s(:number)}"
          type_ids = items.keys
          type_keys =  type_ids.map { |t| "#{market_key}.types.#{t}.stats" }
          market_stats = markets_reader.mapped_mget(*type_keys)
                                       .transform_keys! { |k| k.split('.')[-2].to_i }
                                       .transform_values! { |j| Oj.load(j) if j.present? }

          stats = market_stats.each_with_object({}) do |(type_id, type_stats), h|
            unless type_stats
              type_stats = {}
              error "No current type stats for #{type_id} in #{market_id}"
            end

            buy_attrs = type_stats[:buy]&.transform_keys! { |k| :"buy_#{k}" } || {}
            sell_attrs = type_stats[:sell]&.transform_keys! { |k| :"sell_#{k}" } || {}

            h[type_id] = {
              time:,
              market_id:,
              type_id: type_stats[:type_id],
              buy_sell_spread: type_stats[:buy_sell_spread],
              mid_price: type_stats[:mid_price]
            }.merge!(buy_attrs).merge!(sell_attrs)
          end

          stats.transform_values! { |s| s.slice(*AppraisalItem.column_names.map(&:to_sym)) }

          Rails.logger.debug stats

          stats
        end
    end

    def type_ids
      items.keys
    end
  end
end
