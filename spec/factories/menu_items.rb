FactoryBot.define do
  factory :menu_item, class: HyperKittenMeow::MenuItem do
    sequence(:title) { |n| "Title#{n}" }
    menu
    position { 1 }
  end
end
