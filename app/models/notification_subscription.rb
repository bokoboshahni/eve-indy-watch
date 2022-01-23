# frozen_string_literal: true

# ## Schema Information
#
# Table name: `notification_subscriptions`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`notification_type`**  | `text`             | `not null`
# **`subscriber_type`**    | `string`           | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`slack_webhook_id`**   | `bigint`           |
# **`subscriber_id`**      | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_notification_subscriptions_on_slack_webhook_id`:
#     * **`slack_webhook_id`**
# * `index_notification_subscriptions_on_subscriber`:
#     * **`subscriber_type`**
#     * **`subscriber_id`**
# * `index_unique_notification_subscriptions` (_unique_):
#     * **`subscriber_id`**
#     * **`subscriber_type`**
#     * **`notification_type`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`slack_webhook_id => slack_webhooks.id`**
#
class NotificationSubscription < ApplicationRecord
  belongs_to :subscriber, polymorphic: true
  belongs_to :slack_webhook, inverse_of: :notification_subscriptions, optional: true

  validates :notification_type, presence: true

  def notification_class
    notification_type.safe_constantize
  end
end
