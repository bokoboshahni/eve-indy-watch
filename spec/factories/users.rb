# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    character { association :character, :with_alliance }

    trait :admin do
      admin { true }
    end

    factory :admin_user, traits: %i[admin]
  end
end
