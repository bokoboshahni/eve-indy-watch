# frozen_string_literal: true

FactoryBot.define do
  factory :station do
    association :owner, factory: :corporation
    association :solar_system
    association :type

    id { Faker::Number.within(range: 60_000_000..64_000_000) }
    name { "#{solar_system.name} I - Moon 1 - #{Faker::Space.agency}" }
  end
end
