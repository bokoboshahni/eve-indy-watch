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
require 'rails_helper'

RSpec.describe NotificationSubscription, type: :model do
end
