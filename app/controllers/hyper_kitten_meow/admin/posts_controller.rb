module HyperKittenMeow
  module Admin
    class PostsController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::PostsController
    end
  end
end
