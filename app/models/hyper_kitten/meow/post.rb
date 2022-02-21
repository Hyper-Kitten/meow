module HyperKitten::Meow
  class Post < ApplicationRecord
    belongs_to :user
    has_rich_text :body
  end
end
