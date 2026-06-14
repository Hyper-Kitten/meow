module HyperKittenMeow
  module Concerns
    module Models
      module ContentBlock
        extend ActiveSupport::Concern

        included do
          belongs_to :page,
            class_name: "HyperKittenMeow::Page",
            foreign_key: "page_id",
            inverse_of: :content_blocks

          validates_presence_of :name
          validates_uniqueness_of :name, scope: :page_id

          has_rich_text :body
        end
      end
    end
  end
end
