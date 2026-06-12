# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Posts::New < Views::Admin::Base
    include Views::Admin::Posts::Concerns::PostForm

    def initialize(post:)
      @post = post
    end

    def view_template
      section do
        render Components::PageHeader.new(title: "New Post", eyebrow: "Draft") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_posts_path, "Back to Posts", scheme: :outline_secondary, icon: "arrow-left")
        end

        render_post_form(
          @post,
          url: hyper_kitten_meow.admin_posts_path,
          method: :post,
          cancel_path: hyper_kitten_meow.admin_posts_path
        )
      end
    end
  end
end
