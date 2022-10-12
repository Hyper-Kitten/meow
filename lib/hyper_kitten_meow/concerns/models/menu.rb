module HyperKittenMeow
  module Concerns
    module Models
      module Menu
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable

        included do
          validates_presence_of :name
          has_many :menu_items,
            -> { order(position: :asc) },
            class_name: "HyperKittenMeow::MenuItem",
            dependent: :destroy

          accepts_nested_attributes_for :menu_items,
            allow_destroy: true,
            reject_if: :all_blank

          sluggify :slug, generated_from: :name
        end

        def to_param
          slug
        end
      end
    end
  end
end
