# frozen_string_literal: true

FactoryBot.define do
  factory :character do
    id { Faker::Number.within(range: 90_000_000..98_000_000) }
    corporation
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Name.name }

    trait :with_alliance do
      alliance
      corporation { association :corporation, alliance: alliance }
    end
  end
end
