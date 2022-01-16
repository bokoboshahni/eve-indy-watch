# frozen_string_literal: true

module ProcurementOrdersHelper
  def procurement_order_status_bg_color(order)
    case order.status.to_sym
    when :draft
      'bg-gray-100'
    when :available
      'bg-pink-100'
    when :in_progress
      order.delivered_unconfirmed? ? 'bg-yellow-100' : 'bg-blue-100'
    when :delivered
      'bg-green-100'
    end
  end

  def procurement_order_status_text_color(order)
    case order.status.to_sym
    when :draft
      'text-gray-800'
    when :available
      'text-pink-800'
    when :in_progress
      order.delivered_unconfirmed? ? 'text-yellow-800' : 'text-blue-800'
    when :delivered
      'text-green-800'
    end
  end
end
