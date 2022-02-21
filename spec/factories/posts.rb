FactoryBot.define do
  factory :post, class: HyperKitten::Meow::Post do
    sequence(:title) { |n| "Title#{n}" }
    body { "my post" }
    summary { "my summary" }
    association :user
  end
end
