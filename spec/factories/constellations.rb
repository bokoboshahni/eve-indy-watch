# frozen_string_literal: true

FactoryBot.define do
  factory :constellation do
    association :region

    id { Faker::Number.within(range: 20_000_000..21_000_000) }
    name { Faker::Space.constellation }
  end
end
