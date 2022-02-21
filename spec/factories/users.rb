FactoryBot.define do
  factory :user, class: HyperKitten::Meow::User do
    email { "kitten@kitten.com" }
    name { "Baker Biscuit Boi" }
    password { "password" }
  end
end
