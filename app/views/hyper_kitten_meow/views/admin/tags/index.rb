# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Tags::Index < Views::Admin::Base
    include Phlex::Rails::Helpers::ButtonTo

    def initialize(tags:, pagy:)
      @tags = tags
      @pagy = pagy
    end

    def view_template
      section(class: "tags") do
        render Components::PageHeader.new(title: "Tags") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_tag_path, "Add New")
        end

        render Components::Table.new(collection: @tags) do |t|
          t.column "Label", method_name: :label
          t.column "Actions" do |tag|
            div(class: "input-group") do
              render Components::LinkButton.new(
                hyper_kitten_meow.edit_admin_tag_path(tag),
                "Edit",
                scheme: :sm_outline_info
              )
              button_to "Delete",
                hyper_kitten_meow.admin_tag_path(tag),
                method: :delete,
                class: "btn btn-sm btn-outline-danger",
                form_class: "d-inline"
            end
          end
          t.footer do
            render Components::Pagination.new(pagy: @pagy)
          end
        end
      end
    end
  end
end
