module HyperKitten
  module Meow
    module Admin
      class TagsController < AdminController
        include ::HyperKitten::Meow::Concerns::Controllers::Admin::TagsController
      end
    end
  end
end
