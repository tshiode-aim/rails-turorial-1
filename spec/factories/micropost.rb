FactoryBot.define do
  factory :micropost do
    association :user
    content { Faker::Lorem.sentence(5) }
    created_at { rand(100).hours.ago }
  end
end
