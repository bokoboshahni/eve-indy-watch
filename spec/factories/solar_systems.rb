# frozen_string_literal: true

FactoryBot.define do
  factory :solar_system do
    association :constellation

    id { Faker::Number.within(range: 30_000_000..31_000_000) }
    name { Faker::Space.star }
    security { Faker::Number.within(range: 0.0..1.0) }
  end
end
