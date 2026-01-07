# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Posts::Index < Views::Admin::Base
    def initialize(posts:, pagy:)
      @posts = posts
      @pagy = pagy
    end

    def view_template
      section(class: "posts") do
        render Components::PageHeader.new(title: "Posts") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_post_path, "Add New")
        end

        render Components::Table.new(collection: @posts, tr: {class: "post"}) do |t|
          t.column "Title", method_name: :title
          t.column "Article" do |post|
            post.summary.to_s.truncate(40, separator: " ")
          end
          t.column "Author" do |post|
            post.user.name
          end
          t.column "Slug", method_name: :slug
          t.column "Tags" do |post|
            post.tags.to_a.to_sentence
          end
          t.column "Actions" do |post|
            render Components::LinkButton.new(
              hyper_kitten_meow.edit_admin_post_path(post),
              "Edit",
              scheme: :sm_outline_info
            )
          end
          t.footer do
            render Components::Pagination.new(pagy: @pagy)
          end
        end
      end
    end
  end
end
