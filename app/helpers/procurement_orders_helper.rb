# frozen_string_literal: true

module ProcurementOrdersHelper
  def procurement_order_status_bg_color(order)
    case order.status.to_sym # rubocop:disable Style/HashLikeCase
    when :draft
      'bg-gray-100 dark:bg-zinc-100 dark:bg-zinc-100 dark:saturate-50'
    when :available
      'bg-pink-100 dark:saturate-50'
    when :in_progress
      'bg-blue-100 dark:saturate-50'
    when :unconfirmed
      'bg-yellow-100 dark:saturate-50'
    when :delivered
      'bg-green-100 dark:saturate-50'
    end
  end

  def procurement_order_status_text_color(order)
    case order.status.to_sym # rubocop:disable Style/HashLikeCase
    when :draft
      'text-gray-800 dark:text-zinc-800 dark:text-zinc-800 dark:saturate-50'
    when :available
      'text-pink-800 dark:saturate-50'
    when :in_progress
      'text-blue-800 dark:saturate-50'
    when :unconfirmed
      'text-yellow-800 dark:saturate-50'
    when :delivered
      'text-green-800 dark:saturate-50'
    end
  end
end
