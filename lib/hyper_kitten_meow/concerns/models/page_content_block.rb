module HyperKittenMeow
  module Concerns
    module Models
      module PageContentBlock
        extend ActiveSupport::Concern

        included do
          belongs_to :page, class_name: "HyperKittenMeow::Page", foreign_key: "page_id"
          belongs_to :content_block, class_name: "HyperKittenMeow::ContentBlock", foreign_key: "content_block_id", dependent: :destroy
        end
      end
    end
  end
end
