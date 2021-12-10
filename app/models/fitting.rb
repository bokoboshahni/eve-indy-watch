# ## Schema Information
#
# Table name: `fittings`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`contract_matching_enabled`**  | `boolean`          |
# **`discarded_at`**               | `datetime`         |
# **`name`**                       | `text`             | `not null`
# **`original`**                   | `text`             |
# **`owner_type`**                 | `string`           | `not null`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`owner_id`**                   | `bigint`           | `not null`
# **`type_id`**                    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_fittings_on_discarded_at`:
#     * **`discarded_at`**
# * `index_fittings_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_fittings_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class Fitting < ApplicationRecord
  include Discard::Model

  has_paper_trail

  belongs_to :owner, polymorphic: true
  belongs_to :type, inverse_of: :fittings

  has_many :items, class_name: 'FittingItem', inverse_of: :fitting, dependent: :destroy

  accepts_nested_attributes_for :items

  def self.create_from_eft!(text, owner)
    attributes = ParseEFT.call(text).merge(owner: owner)
    errors = attributes.delete('errors')
    create!(attributes)
  end
end
