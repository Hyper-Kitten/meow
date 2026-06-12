# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Pages::Index < Views::Admin::Base
    def initialize(pages:, pagy:)
      @pages = pages
      @pagy = pagy
    end

    def view_template
      section(class: "pages") do
        render Components::PageHeader.new(title: "Pages", eyebrow: "#{@pagy.count} static pages") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_page_path, "Add New", icon: "plus")
        end

        render Components::Table.new(collection: @pages, tr: {class: "page"}) do |t|
          t.column "Title", class: "cell-title", method_name: :title
          t.column "Slug", class: "cell-mono", method_name: :slug
          t.column "", header_options: {class: "col-actions"}, class: "col-actions" do |page|
            render Components::LinkButton.new(
              hyper_kitten_meow.edit_admin_page_path(page),
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
  end
end
