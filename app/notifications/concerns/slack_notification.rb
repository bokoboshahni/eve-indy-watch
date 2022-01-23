# frozen_string_literal: true

module SlackNotification
  extend ActiveSupport::Concern

  included do
    deliver_by :slack, format: :slack_format, url: :slack_url

    param :subscription
  end

  def slack_blocks; end

  def slack_format
    { channel: slack_webhook.channel, blocks: slack_blocks, unfurl_links: false }
  end

  def slack_url
    slack_webhook.url
  end

  def slack_webhook
    params[:subscription].slack_webhook
  end
end
