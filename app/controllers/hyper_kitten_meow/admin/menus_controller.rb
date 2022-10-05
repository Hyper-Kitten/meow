module HyperKittenMeow
  module Admin
    class MenusController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::MenusController
    end
  end
end
