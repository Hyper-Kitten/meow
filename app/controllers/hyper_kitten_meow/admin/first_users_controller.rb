module HyperKittenMeow
  module Admin
    class FirstUsersController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::FirstUsersController
    end
  end
end
