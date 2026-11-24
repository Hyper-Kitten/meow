FactoryBot.define do
  factory :menu, class: HyperKittenMeow::Menu do
    key { "primary" }
  end

  factory :menu_item, class: HyperKittenMeow::MenuItem do
    menu
    sequence(:position)
    sequence(:label) { |n| "Item #{n}" }
    url { "/somewhere" }

    trait :for_page do
      label { nil }
      url { nil }
      page
    end
  end
end
