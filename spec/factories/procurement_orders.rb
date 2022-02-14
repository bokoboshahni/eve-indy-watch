# frozen_string_literal: true

# ## Schema Information
#
# Table name: `procurement_orders`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`accepted_at`**                | `datetime`         |
# **`appraisal_url`**              | `text`             |
# **`bonus`**                      | `decimal(, )`      |
# **`delivered_at`**               | `datetime`         |
# **`discarded_at`**               | `datetime`         |
# **`estimated_completion_at`**    | `datetime`         |
# **`multiplier`**                 | `decimal(, )`      | `not null`
# **`notes`**                      | `text`             |
# **`published_at`**               | `datetime`         |
# **`requester_name`**             | `text`             |
# **`requester_type`**             | `string`           | `not null`
# **`split_fulfillment_enabled`**  | `boolean`          |
# **`status`**                     | `enum`             | `not null`
# **`supplier_name`**              | `text`             |
# **`supplier_type`**              | `string`           |
# **`target_completion_at`**       | `datetime`         |
# **`tracking_number`**            | `bigint`           |
# **`unconfirmed_at`**             | `datetime`         |
# **`visibility`**                 | `enum`             |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`location_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`supplier_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_procurement_orders_on_discarded_at`:
#     * **`discarded_at`**
# * `index_procurement_orders_on_location_id`:
#     * **`location_id`**
# * `index_procurement_orders_on_requester`:
#     * **`requester_type`**
#     * **`requester_id`**
# * `index_procurement_orders_on_supplier`:
#     * **`supplier_type`**
#     * **`supplier_id`**
#
FactoryBot.define do
  factory :procurement_order do
    association :location, factory: :station_location
    association :requester, factory: :character

    bonus { 0.0 }
    multiplier { 100.0 }
    status { :draft }
    visibility { :everyone }

    trait :available do
      published_at { Time.zone.now }
      status { :available }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :in_progress do
      association :supplier, factory: :character

      published_at { 1.hour.ago }
      accepted_at { Time.zone.now }
      status { :in_progress }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :unconfirmed do
      association :supplier, factory: :character

      published_at { 2.hours.ago }
      accepted_at { 1.hour.ago }
      unconfirmed_at { Time.zone.now }
      status { :unconfirmed }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :delivered do
      association :supplier, factory: :character

      published_at { 3.hours.ago }
      accepted_at { 2.hours.ago }
      unconfirmed_at { 1.hour.ago }
      delivered_at { Time.zone.now }
      status { :delivered }

      items { [association(:procurement_order_item, order: instance)] }
    end

    factory :available_order, traits: %i[available]
    factory :in_progress_order, traits: %i[in_progress]
    factory :unconfirmed_order, traits: %i[unconfirmed]
    factory :delivered, traits: %i[delivered]

    factory :alliance_order do
      association :requester, factory: :alliance
    end

    factory :corporation_order do
      association :requester, factory: :corporation
    end

    factory :user_order do
      association :requester, factory: :character
    end
  end
end
