module HyperKitten
  module Meow
    module Admin
      class PostsController < AdminController
        include ::HyperKitten::Meow::Concerns::Controllers::Admin::PostsController
      end
    end
  end
end
