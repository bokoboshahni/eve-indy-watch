# frozen_string_literal: true

# To deliver this notification:
#
# ProcurementOrder::OrderPublishedNotification.with(post: @post).deliver_later(current_user)
# ProcurementOrder::OrderPublishedNotification.with(post: @post).deliver(current_user)

class ProcurementOrder < ApplicationRecord
  class OrderPublishedNotification < Noticed::Base
    include ActionView::Helpers::NumberHelper
    include SlackNotification

    param :order

    def order
      params[:order]
    end

    def slack_blocks # rubocop:disable Metrics/MethodLength
      message = "📣 An order from *#{order.requester_name}* at _#{order.location_name}_ " \
                "for *#{number_to_currency(order.total, unit: 'ISK', format: '%n %u')}* " \
                "has been made available:\n\n" \
                "#{number_with_delimiter order.items.first.quantity_required} _*#{order.items.first.name}*_"
      message += " and #{order.items.count - 1} more item(s)" if order.items.count > 1

      blocks = [{
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: message
        },
        accessory: {
          type: 'button',
          text: {
            type: 'plain_text',
            text: 'View order details',
            emoji: true
          },
          value: 'order_details',
          url: procurement_order_url(order),
          action_id: 'button-action'
        }
      }]

      if order.target_completion_at
        blocks << {
          type: 'context',
          elements: [

            {
              type: 'mrkdwn',
              text: "🕒 This order has a due date of *#{order.target_completion_at.to_s(:long_date)}*."
            }
          ]
        }
      end

      blocks << { type: 'divider' }
      blocks
    end
  end
end
