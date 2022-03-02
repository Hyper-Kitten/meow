FactoryBot.define do
  factory :user, class: HyperKittenMeow::User do
    sequence(:email) { |n| "hyper#{n}@kitten.com" }
    name { "Baker Biscuit Boi" }
    password { "password" }
  end
end
