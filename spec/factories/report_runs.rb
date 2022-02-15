# frozen_string_literal: true

# ## Schema Information
#
# Table name: `report_runs`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`duration`**    | `interval`         | `not null`
# **`exception`**   | `jsonb`            |
# **`report`**      | `text`             | `not null`
# **`started_at`**  | `datetime`         | `not null`
# **`status`**      | `enum`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint`           |
#
# ### Indexes
#
# * `index_report_runs_on_user_id`:
#     * **`user_id`**
#
FactoryBot.define do
  factory :report_run do
  end
end
