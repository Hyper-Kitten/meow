module HyperKittenMeow
  class Post < ApplicationRecord
    include ::HyperKittenMeow::Concerns::Models::Post
  end
end
