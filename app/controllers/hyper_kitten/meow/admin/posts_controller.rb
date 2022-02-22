module HyperKitten
  module Meow
    module Admin
      class PostsController < AdminController
        include Concerns::Controller::Admin::PostsController
      end
    end
  end
end
