module HyperKitten
  module Meow
    class PostsController < ApplicationController
      include Concerns::Controller::PostsController
    end
  end
end
