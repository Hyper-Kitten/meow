module HyperKittenMeow
  module Admin
    class UsersController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::UsersController
    end
  end
end
