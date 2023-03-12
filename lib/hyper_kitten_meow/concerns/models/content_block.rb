module HyperKittenMeow
  module Concerns
    module Models
      module ContentBlock
        extend ActiveSupport::Concern

        included do
          validates_presence_of :name
          has_rich_text :body
        end
      end
    end
  end
end
