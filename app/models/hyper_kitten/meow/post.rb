module HyperKitten
  module Meow
    class Post < ApplicationRecord
      include ::HyperKitten::Meow::Concerns::Models::Post
    end
  end
end
