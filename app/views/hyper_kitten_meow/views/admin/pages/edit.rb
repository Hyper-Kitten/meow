# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Pages::Edit < Views::Admin::Base
    include Views::Admin::Pages::Concerns::PageForm

    def initialize(page:, templates_and_content_blocks:)
      @page = page
      @templates_and_content_blocks = templates_and_content_blocks
    end

    def view_template
      section(class: "edit-page") do
        render Components::PageHeader.new(title: "Editing Page: #{@page.title}") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_pages_path, "Back to Pages", scheme: :secondary)
        end

        render_page_form(
          @page,
          templates_and_content_blocks: @templates_and_content_blocks,
          url: hyper_kitten_meow.admin_page_path(@page),
          method: :patch,
          cancel_path: hyper_kitten_meow.admin_pages_path
        )
      end
    end
  end
end
