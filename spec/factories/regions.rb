# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    id { Faker::Number.within(range: 10_000_000..11_000_000) }
    name { Faker::Space.nebula }
  end
end
