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
class KillmailFitting < ApplicationRecord
  self.primary_keys = :killmail_id, :fitting_id

  belongs_to :fitting, inverse_of: :killmail_fittings
  belongs_to :killmail, inverse_of: :killmail_fittings

  scope :matching, -> { joins(:fitting).where('similarity >= COALESCE(fittings.killmail_match_threshold, 1.0)') }
end
