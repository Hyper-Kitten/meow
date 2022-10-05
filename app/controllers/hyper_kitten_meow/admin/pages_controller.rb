module HyperKittenMeow
  module Admin
    class PagesController < AdminController
      include ::HyperKittenMeow::Concerns::Controllers::Admin::PagesController
    end
  end
end
