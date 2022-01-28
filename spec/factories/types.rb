# frozen_string_literal: true

FactoryBot.define do
  factory :type do
    association :group

    id { Faker::Number.within(range: 0..1_000_000) }
    name { Faker::Food.dish }
  end
end
