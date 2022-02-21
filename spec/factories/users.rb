FactoryBot.define do
  factory :user, class: HyperKitten::Meow::User do
    sequence(:email) { |n| "hyper#{n}@kitten.com" }
    name { "Baker Biscuit Boi" }
    password { "password" }
  end
end
