# frozen_string_literal: true

module HyperKittenMeow
  class Components::PostSummary < Components::Base
    def initialize(post:)
      @post = post
    end

    def view_template
      h3 { @post.title }
      p { @post.summary }
    end
  end
end
