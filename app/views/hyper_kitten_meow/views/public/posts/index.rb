# frozen_string_literal: true

module HyperKittenMeow
  class Views::Public::Posts::Index < Views::Public::Base
    def initialize(posts:, pagy:)
      @posts = posts
      @pagy = pagy
    end

    def view_template
      div(class: "container") do
        @posts.each do |post|
          render Components::PostSummary.new(post: post)
        end
        render Components::Pagination.new(pagy: @pagy)
      end
    end
  end
end
