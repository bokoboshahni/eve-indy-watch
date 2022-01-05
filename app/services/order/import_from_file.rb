class Order < StatisticsRecord
  class ImportFromFile < ApplicationService
    def initialize(file)
      super

      @file = file
      @location_id = File.basename(File.dirname(file)).to_i
      @time = File.basename(file).delete_suffix('.json').to_datetime
      @orders = []
      @events = []
    end

    def call
      find_location
      load_esi_orders
      load_active_orders

      # Order.transaction do
      #   discover_new_orders
      #   discover_changed_orders
      #   discover_deleted_orders
      #   import_orders
      # end
    end

    private

    attr_reader :file, :time, :location, :location_id, :order_location_ids,
                :active_orders, :active_order_ids, :esi_orders, :esi_order_ids,
                :order_records, :event_records

    def find_location
      @location =
        if (10_000_000..11_000_000) === location_id
          Region.find(location_id)
        else
          Structure.find(location_id)
        end

      @order_location_ids =
        if location.is_a?(Region)
          Station.joins(solar_system: { constellation: :region }).where('constellations.region_id': location_id) +
          Structure.joins(solar_system: { constellation: :region }).where('constellations.region_id': location_id)
        else
          location_id
        end
    end

    def load_esi_orders
      @esi_orders = Oj.load(File.read(file))
      @esi_order_ids = @esi_orders.map { |o| o['order_id'] }

      debug("Loaded #{esi_orders.count} orders from #{file}")
    end

    def load_active_orders
      @active_orders = Order.active.by_location(order_location_ids).pluck(:id, :is_buy_order, :price, :volume_remain, :volume_total, :issued_at, :duration)
      @active_order_ids = @active_orders.map(&:first)

      debug("Found #{active_orders.count} active orders for #{order_location_ids.count} locations in #{location.log_name}")
    end

    def discover_new_orders
      new_orders = esi_orders.each do |o|
        next if open_order_ids.include?(o['id'])

        o['issued_at'] = o.delete('issued')
        o['range'] = o['range'].to_sym
        o['region_id'] = location.is_a?(Region) ? location_id : location.region_id
        o['solar_system_id'] = location.solar_system_id if location.is_a?(Structure)
        o['side'] = o.delete('is_buy_order') ? :buy : :sell
        o['status'] = :active

        e = {
          order_id: o['id'],
          action: :create,
          price: o['price'],
          volume: o['volume_remain'],
          time: time
        }

        e['type'] =
          if o['volume_remain'] < o['volume_total']
            :market_limit
          elsif o['volume_remain'] == 0
            :market
          else
            :resting_limit
          end

        orders << o
        events << e
      end

      debug("Found #{new_orders.count} new orders in #{file}")
    end

    def discover_changed_orders
      open_orders.each do |o|
        next if esi_order_ids.exclude?(o.id)

        esi_o = esi_order(o.id)

        next unless esi_o['volume_remain'] != o.volume_remain || esi_o['price'].to_f != o.price.to_f

        ap o
        ap esi_o
        debug esi_o['volume_remain'] == o.volume_remain
        debug esi_o.fetch('price')
        debug o.price.to_d

        o.price = esi_o['price'],
        o.volume_remain = esi_o['volume_remain']
        o.status = :filled if o.volume_remain == 0

        e = {
          order_id: o.id,
          action: :change,
          price: esi_o['price'],
          volume: esi_o['volume_remain'],
          fill: o.volume_remain - esi_o['volume_remain'],
          time: time
        }

        e[:type] =
          if esi_o['price'] != o.price
            :pacman
          elsif esi_o['volume_remain'] < o.volume_remain
            :resting_limit
          else
            :unknown
          end

        orders << o
        events << e

        self.changed_count += 1
      end

      debug("Found #{changed_count} changed orders in #{file}")
    end

    def discover_deleted_orders
      open_orders.select { |id| all_esi_order_ids.exclude?(id) }.map do |id|
        esi_o = esi_order(o.id)

        o.status = :deleted

        e = {
          order_id: o.id,
          action: :delete,
          price: o.price,
          volume: o.volume_remain,
          time: time
        }

        e['type'] =
          if o.volume_remain == 0
            :resting_limit
          elsif o.volume_remain == o.volume_total
            :flashed_limit
          else
            :unknown
          end

        o.events.build(e)

        orders << { id: o.id }
        o
      end
      deleted_order_updates.compact!

      orders.push(*deleted_order_updates)

      debug("Found #{deleted_order_updates.count} deleted orders") if deleted_order_updates.any?
    end

    def import_orders
      if orders.empty?
        debug("No orders to update from #{file}")
        return
      end

      imported_ids = Order.import(
        orders,
        on_duplicate_key_update: { conflict_target: %i[id], columns: %i[price status volume_remain] },
        recursive: true, raise_error: true, returning: :id
      ).results

      debug("Processed #{imported_ids.count} orders from #{file}")
    end

    def open_order_ids
      @open_order_ids ||= open_orders.pluck(:id)
    end

    def esi_order(id)
      esi_orders.find { |o| o['id'] == id }
    end

    def esi_order_ids
      @esi_order_ids ||= esi_orders.map { |o| o['id'] }
    end
  end
end
