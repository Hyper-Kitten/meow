module HyperKittenMeow
  module Admin
    class AdminController < ActionController::Base
      include ::HyperKittenMeow::Concerns::Controllers::Admin::AdminController
    end
  end
end
