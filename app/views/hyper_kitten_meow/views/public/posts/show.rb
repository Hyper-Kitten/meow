# frozen_string_literal: true

module HyperKittenMeow
  class Views::Public::Posts::Show < Views::Public::Base
    def initialize(post:)
      @post = post
    end

    def page_title
      @post.title
    end

    def view_template
      article do
        h1 { @post.title }
        raw safe(@post.body)
      end
    end
  end
end
