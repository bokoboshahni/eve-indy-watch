# frozen_string_literal: true

# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`published`**   | `boolean`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class Category < ApplicationRecord
  CHARGE_CATEGORY_NAME = 'Charge'
  DRONE_CATEGORY_NAME = 'Drone'
  FIGHTER_CATEGORY_NAME = 'Fighter'
  IMPLANT_CATEGORY_NAME = 'Implant'
  MODULE_CATEGORY_NAMES = ['Module', 'Subsystem', 'Structure Module'].freeze

  has_many :groups, dependent: :restrict_with_exception

  has_many :types, through: :groups
end
