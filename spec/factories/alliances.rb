# frozen_string_literal: true

FactoryBot.define do
  factory :alliance do
    id { Faker::Number.within(range: 99_000_000..100_000_000) }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Company.name }
    ticker { Faker::Finance.ticker }
  end
end
