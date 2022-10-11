module HyperKittenMeow
  module Concerns
    module Models
      module MenuItem
        extend ActiveSupport::Concern

        included do
          acts_as_list scope: :menu

          belongs_to :menu
          belongs_to :page, optional: true

          validates_presence_of :menu, :title, :position
        end

        def target
          new_window ? "_blank" : "_self"
        end
      end
    end
  end
end
