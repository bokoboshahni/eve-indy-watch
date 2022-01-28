# frozen_string_literal: true

FactoryBot.define do
  factory :procurement_order_item do
    association :order, factory: :procurement_order
    association :type

    multiplier { 100.0 }
    price { Faker::Number.within(range: 0.01..10_000_000_000.0).round(2).to_s }
    quantity_required { Faker::Number.within(range: 1..100_000) }
  end
end
