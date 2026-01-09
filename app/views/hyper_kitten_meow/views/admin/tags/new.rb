# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Tags::New < Views::Admin::Base
    include Views::Admin::Tags::Concerns::TagForm

    def initialize(tag:)
      @tag = tag
    end

    def view_template
      section(class: "tags") do
        render Components::PageHeader.new(title: "New Tag") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_tags_path, "Back to Tags", scheme: :secondary)
        end

        render_tag_form(
          @tag,
          url: hyper_kitten_meow.admin_tags_path,
          method: :post,
          cancel_path: hyper_kitten_meow.admin_tags_path
        )
      end
    end
  end
end
