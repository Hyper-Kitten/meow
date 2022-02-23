module HyperKitten
  module Meow
    class PostsController < ApplicationController
      include ::HyperKitten::Meow::Concerns::Controllers::PostsController
    end
  end
end
