FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { password }
    admin { false }
    activated { true }

    trait :admin do
      name { 'Michael Example' }
      email { 'michael_test@example.com' }
      admin { true }
    end

    trait :non_admin do
      name { 'Sterling Archer' }
      email { 'duchess@example.gov' }
      admin { false }
    end

    trait :prepare_reset do
      after(:create, &:create_reset_digest)
    end
  end
end
