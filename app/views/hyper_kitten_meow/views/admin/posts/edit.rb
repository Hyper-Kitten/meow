# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Posts::Edit < Views::Admin::Base
    include Views::Admin::Posts::Concerns::PostForm

    def initialize(post:)
      @post = post
    end

    def view_template
      section(class: "edit-post") do
        render Components::PageHeader.new(title: "Edit Post", eyebrow: "Editing") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_posts_path, "Back to Posts", scheme: :outline_secondary, icon: "arrow-left")
        end

        render_post_form(
          @post,
          url: hyper_kitten_meow.admin_post_path(@post),
          method: :patch,
          cancel_path: hyper_kitten_meow.admin_posts_path
        )
      end
    end
  end
end
