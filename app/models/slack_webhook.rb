# frozen_string_literal: true

# ## Schema Information
#
# Table name: `slack_webhooks`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`channel`**         | `text`             | `not null`
# **`icon_emoji`**      | `text`             |
# **`name`**            | `text`             | `not null`
# **`owner_type`**      | `string`           |
# **`url_ciphertext`**  | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`owner_id`**        | `bigint`           |
#
# ### Indexes
#
# * `index_slack_webhooks_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_unique_slack_webhooks_by_owner` (_unique_):
#     * **`owner_id`**
#     * **`owner_type`**
#     * **`name`**
#
class SlackWebhook < ApplicationRecord
  encrypts :url

  belongs_to :owner, polymorphic: true

  has_many :notification_subscriptions, inverse_of: :slack_webhook

  validates :channel, :name, :url, presence: true
end
