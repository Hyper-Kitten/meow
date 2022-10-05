FactoryBot.define do
  factory :page, class: HyperKittenMeow::Page do
    sequence(:title) { |n| "Title#{n}" }
    body { "Ipsum lorem" }
  end
end
