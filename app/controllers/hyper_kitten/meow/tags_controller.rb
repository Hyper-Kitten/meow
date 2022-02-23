module HyperKitten
  module Meow
    class TagsController < ApplicationController
      include ::HyperKitten::Meow::Concerns::Controllers::TagsController
    end
  end
end
