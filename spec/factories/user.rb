FactoryBot.define do
  factory :user do
    name { 'Michael Example' }
    email { 'michael_test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
