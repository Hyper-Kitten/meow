module HyperKittenMeow
  module Concerns
    module Models
      module Menu
        extend ActiveSupport::Concern

        included do
          validates_presence_of :name
          has_many :menu_items,
            class_name: "HyperKittenMeow::MenuItem",
            dependent: :destroy

          accepts_nested_attributes_for :menu_items,
            allow_destroy: true,
            reject_if: :all_blank
        end

        class_methods do
        end
      end
    end
  end
end
