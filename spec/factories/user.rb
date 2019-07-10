FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { password }
    admin { false }

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
  end
end
