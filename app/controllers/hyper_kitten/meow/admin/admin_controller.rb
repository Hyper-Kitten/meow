module HyperKitten
  module Meow
    module Admin
      class AdminController < ApplicationController
        include Concerns::Controller::Admin::AdminController
      end
    end
  end
end
