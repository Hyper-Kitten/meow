# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Pages::Index < Views::Admin::Base
    def initialize(pages:, pagy:)
      @pages = pages
      @pagy = pagy
    end

    def view_template
      section(class: "pages") do
        render Components::PageHeader.new(title: "Pages") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_page_path, "Add New")
        end

        render Components::Table.new(collection: @pages, tr: {class: "page"}) do |t|
          t.column "Title", method_name: :title
          t.column "Slug", method_name: :slug
          t.column "Actions" do |page|
            render Components::LinkButton.new(
              hyper_kitten_meow.edit_admin_page_path(page),
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
