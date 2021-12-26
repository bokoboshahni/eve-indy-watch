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
# **`status`**      | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint`           |
#
# ### Indexes
#
# * `index_report_runs_on_report`:
#     * **`report`**
# * `index_report_runs_on_user_id`:
#     * **`user_id`**
#
module Statistics
  class ReportRun < ApplicationRecord
    attribute :duration, :interval

    belongs_to :user, inverse_of: :report_runs, optional: true
  end
end
