# frozen_string_literal: true

class MarketOrder < ApplicationRecord
  class ImportPage < ApplicationService
    def initialize(page)
      super

      @page = page
      @order_location_ids = Set.new
    end

    def call
      return if page.imported?

      page_path = Rails.root.join("tmp/market_orders/#{batch.id}/#{page.page}.json")

      data = Oj.load(File.read(page_path))
      orders = data.each_with_object([]) { |o, a| a << map_order(o) }
      orders.uniq! { |o| [o[:location_id], o[:order_id]] }

      page.transaction do
        page.lock!

        results = MarketOrder.import!(orders, on_duplicate_key_update: { conflict_target: %i[location_id order_id time], columns: :all })
        raise "Failed to load market orders from batch #{batch.id}/#{page.page}" if results.failed_instances.any?

        page.update!(imported_at: Time.zone.now, order_count: orders.count, import_count: results.ids.count)
      end

      debug("Imported #{orders.count} market orders(s) for #{location.name} (#{location.id})")

      order_location_ids
    rescue ActiveRecord::Deadlocked
      warn("Market order batch page #{batch.id}/#{page.page} for #{location.log_name} is currently being processed.")
    end

    private

    attr_reader :page, :order_location_ids

    delegate :batch, to: :page

    delegate :location, :time, to: :batch

    def map_order(data)
      order = data.symbolize_keys
      order[:batch_page_id] = [batch.id, page.page]
      order[:kind] = order.delete(:is_buy_order) ? 'buy' : 'sell'
      order[:location_type] = location_type(order[:location_id])
      order[:issued_at] = order.delete(:issued)
      order[:time] = time
      order[:solar_system_id] = location.is_a?(Structure) ? location.solar_system_id : order.delete(:system_id)

      order_location_ids.add(order[:location_id])

      order
    end
  end
end
