FactoryBot.define do
  factory :page, class: HyperKittenMeow::Page do
    sequence(:title) { |n| "Title#{n}" }
    body { "my page" }
  end
end
