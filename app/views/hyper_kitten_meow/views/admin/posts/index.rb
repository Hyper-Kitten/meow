# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Posts::Index < Views::Admin::Base
    def initialize(posts:, pagy:, published_count:)
      @posts = posts
      @pagy = pagy
      @published_count = published_count
    end

    def view_template
      section(class: "posts") do
        render Components::PageHeader.new(title: "Posts", eyebrow: posts_eyebrow) do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_post_path, "Add New", icon: "plus")
        end

        render Components::Table.new(collection: @posts, tr: {class: "post"}) do |t|
          t.column "Title" do |post|
            div(class: "cell-title") { post.title }
            div(class: "cell-sub") { post.slug }
          end
          t.column "Author" do |post|
            post.user.name
          end
          t.column "Tags" do |post|
            div(class: "mw-tags") do
              post.tags.to_a.each { |tag| render Components::Tag.new(tag.label) }
            end
          end
          t.column "Status" do |post|
            render Components::StatusBadge.new(published: post.published?)
          end
          t.column "Date", class: "cell-mono" do |post|
            post.published_at&.strftime("%m/%d/%Y") || "—"
          end
          t.column "", header_options: {class: "col-actions"}, class: "col-actions" do |post|
            render Components::LinkButton.new(
              hyper_kitten_meow.edit_admin_post_path(post),
              "Edit",
              scheme: :sm_outline_info,
              icon: "pen-line"
            )
          end
          t.footer do
            render Components::Pagination.new(pagy: @pagy)
          end
        end
      end
    end

    private

    def posts_eyebrow
      "#{@pagy.count} total · #{@published_count} published"
    end
  end
end
