FactoryBot.define do
  factory :menu, class: HyperKittenMeow::Menu do
    sequence(:name) { |n| "Title#{n}" }
  end
end
