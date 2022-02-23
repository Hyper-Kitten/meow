module HyperKitten
  module Meow
    module Admin
      class AdminController < ApplicationController
        include ::HyperKitten::Meow::Concerns::Controllers::Admin::AdminController
      end
    end
  end
end
