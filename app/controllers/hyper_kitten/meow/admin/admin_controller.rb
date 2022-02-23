module HyperKitten
  module Meow
    module Admin
      class AdminController < ActionController::Base
        include ::HyperKitten::Meow::Concerns::Controllers::Admin::AdminController
      end
    end
  end
end
