# frozen_string_literal: true

class MarketOrder < ApplicationRecord
  class ImportPage < ApplicationService
    def initialize(page)
      super

      @page = page
      @order_location_ids = Set.new
    end

    def call
      return if page.started? || page.imported?

      page.update!(started_at: Time.zone.now)

      data = Oj.load(page.orders)
      orders = data.each_with_object([]) { |o, a| a << map_order(o) }
      orders.uniq! { |o| [o[:location_id], o[:order_id]] }

      page.update!(order_count: orders.count)

      page.transaction do
        results = MarketOrder.import!(orders, on_duplicate_key_update: { conflict_target: %i[location_id order_id time], columns: :all })
        raise "Failed to load market orders from batch #{batch.id}/#{page.page}" if results.failed_instances.any?

        page.update!(imported_at: Time.zone.now, import_count: results.ids.count)
      end

      debug("Imported #{orders.count} market orders(s) for #{location.name} (#{location.id})")

      order_location_ids
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
