# frozen_string_literal: true

class Market < ApplicationRecord
  class CalculateTypeStatisticsQueuer < ApplicationService
    def initialize(market, time, force: false)
      super

      @market = market
      @time = time
      @force = force
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      market.update_ingestion_info!

      time_key = time.to_s(:number)
      existing_snapshot = market.snapshot_keys[time_key.to_i]
      if existing_snapshot && !force
        debug("Market statistics have already been generated for #{log_name} at #{time.to_s(:db)}")
        return
      end

      type_ids =
        if market.regional?
          type_ids_key = "orders.#{source_location_id}.#{time_key}.type_ids"
          orders_writer.smembers(type_ids_key)
        else
          market.market_locations.pluck(:location_id).each_with_object([]) do |location_id, a|
            type_ids_key = "orders.#{source_location_id}.#{time_key}.type_ids_by_location.#{location_id}"
            ids = orders_writer.smembers(type_ids_key)
            a.push(*ids)
          end
        end

      begin
        args = type_ids.uniq.each_slice((type_ids.size / 100.0).round).to_a.each_with_object([]) do |type_ids, a| # rubocop:disable Lint/ShadowingOuterLocalVariable
          a << [market.id, type_ids, time_key, force]
        end
      rescue ArgumentError => e
        raise "No types for #{log_name} at #{time.to_s(:db)}" if /slice size/.match?(e.message)
      end

      unless args.any?
        warn("No types to calculate for #{log_name} at #{time.to_s(:db)}")
        return
      end

      batch = Sidekiq::Batch.new
      batch.callback_queue = :markets
      batch.description = "market#calculate_type_statistics(#{market_id}, #{time_key})"
      batch.on(:success, Market::CalculateTypeStatisticsCallback, market_id: market_id, time: time_key)
      batch.jobs { Market::CalculateTypeStatisticsWorker.perform_bulk(args) }

      info("Queued order book calculation with #{args.count} jobs for #{type_ids.count} type(s) for #{log_name} at #{time.to_s(:db)}")
    end

    private

    attr_reader :market, :time, :force

    delegate :log_name, :source_location_id, to: :market
    delegate :id, to: :market, prefix: true
  end
end
