# frozen_string_literal: true

# ## Schema Information
#
# Table name: `killmail_fittings`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`items`**        | `jsonb`            |
# **`similarity`**   | `decimal(, )`      | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`fitting_id`**   | `bigint`           | `not null, primary key`
# **`killmail_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_killmail_fittings_on_fitting_id`:
#     * **`fitting_id`**
# * `index_killmail_fittings_on_killmail_id`:
#     * **`killmail_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`killmail_id => killmails.id`**
#
FactoryBot.define do
  factory :killmail_fitting do
  end
end
