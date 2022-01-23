# frozen_string_literal: true

# To deliver this notification:
#
# ProcurementOrder::OrderAcceptedNotification.with(post: @post).deliver_later(current_user)
# ProcurementOrder::OrderAcceptedNotification.with(post: @post).deliver(current_user)

class ProcurementOrder < ApplicationRecord
  class OrderAcceptedNotification < Noticed::Base
    include ActionView::Helpers::NumberHelper
    include SlackNotification

    param :order

    def order
      params[:order]
    end

    def slack_blocks # rubocop:disable Metrics/MethodLength
      [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "🚀 Order *##{order.number}* for *#{order.requester_name}* at _#{order.location_name}_ has been picked up by *#{order.supplier_name}*."
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
        },
        {
          type: 'divider'
        }
      ]
    end
  end
end
