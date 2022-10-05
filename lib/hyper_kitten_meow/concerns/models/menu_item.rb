module HyperKittenMeow
  module Concerns
    module Models
      module MenuItem
        extend ActiveSupport::Concern

        included do
          acts_as_list scope: :menu

          belongs_to :menu
          belongs_to :page

          validates_presence_of :page, :menu, :title, :position
        end
      end
    end
  end
end
