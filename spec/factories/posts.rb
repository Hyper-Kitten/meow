FactoryBot.define do
  factory :post, class: HyperKittenMeow::Post do
    sequence(:title) { |n| "Title#{n}" }
    body { "my post" }
    summary { "my summary" }
    association :user
  end
end
