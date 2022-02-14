# frozen_string_literal: true

# ## Schema Information
#
# Table name: `notifications`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`params`**          | `jsonb`            |
# **`read_at`**         | `datetime`         |
# **`recipient_type`**  | `string`           | `not null`
# **`type`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`recipient_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_notifications_on_read_at`:
#     * **`read_at`**
# * `index_notifications_on_recipient`:
#     * **`recipient_type`**
#     * **`recipient_id`**
#
FactoryBot.define do
  factory :notification do
  end
end
