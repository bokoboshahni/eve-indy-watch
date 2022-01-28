# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    id { Faker::Number.within(range: 0..1_000_000) }
    name { Faker::Food.dish }
    published { true }
  end
end
