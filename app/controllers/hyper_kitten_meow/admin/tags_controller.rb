module HyperKittenMeow
  module Admin
    class TagsController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::TagsController
    end
  end
end
