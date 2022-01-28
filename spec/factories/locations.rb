# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    name { locatable.name }

    factory :station_location do
      association :locatable, factory: :station
    end
  end
end
