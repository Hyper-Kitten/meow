module HyperKitten
  module Meow
    module Admin
      class TagsController < AdminController
        include Concerns::Controller::Admin::TagsController
      end
    end
  end
end
