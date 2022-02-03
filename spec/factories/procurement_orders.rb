# frozen_string_literal: true

FactoryBot.define do
  factory :procurement_order do
    association :location, factory: :station_location
    association :requester, factory: :character

    bonus { 0.0 }
    multiplier { 100.0 }
    status { :draft }
    visibility { :everyone }

    trait :available do
      published_at { Time.zone.now }
      status { :available }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :in_progress do
      association :supplier, factory: :character

      published_at { 1.hour.ago }
      accepted_at { Time.zone.now }
      status { :in_progress }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :unconfirmed do
      association :supplier, factory: :character

      published_at { 2.hours.ago }
      accepted_at { 1.hour.ago }
      unconfirmed_at { Time.zone.now }
      status { :unconfirmed }

      items { [association(:procurement_order_item, order: instance)] }
    end

    trait :delivered do
      association :supplier, factory: :character

      published_at { 3.hours.ago }
      accepted_at { 2.hours.ago }
      unconfirmed_at { 1.hour.ago }
      delivered_at { Time.zone.now }
      status { :delivered }

      items { [association(:procurement_order_item, order: instance)] }
    end

    factory :available_order, traits: %i[available]
    factory :in_progress_order, traits: %i[in_progress]
    factory :unconfirmed_order, traits: %i[unconfirmed]
    factory :delivered, traits: %i[delivered]

    factory :alliance_order do
      association :requester, factory: :alliance
    end

    factory :corporation_order do
      association :requester, factory: :corporation
    end

    factory :user_order do
      association :requester, factory: :character
    end
  end
end
