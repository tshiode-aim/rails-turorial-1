FactoryBot.define do
  factory :michael, class: User do
    name { 'Michael Example' }
    email { 'michael_test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end

  factory :archer, class: User do
    name { 'Sterling Archer' }
    email { 'duchess@example.gov' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
