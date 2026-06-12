# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Tags::Index < Views::Admin::Base
    def initialize(tags:, pagy:)
      @tags = tags
      @pagy = pagy
    end

    def view_template
      section(class: "tags") do
        render Components::PageHeader.new(title: "Tags", eyebrow: "#{@pagy.count} in use") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_tag_path, "Add New", icon: "plus")
        end

        render Components::Table.new(collection: @tags) do |t|
          t.column "Label" do |tag|
            render Components::Tag.new(tag.label, active: true)
          end
          t.column "", header_options: {class: "col-actions"}, class: "col-actions" do |tag|
            render Components::ButtonGroup.new(align: :end) do
              render Components::LinkButton.new(
                hyper_kitten_meow.edit_admin_tag_path(tag),
                "Edit",
                scheme: :sm_outline_info,
                icon: "pen-line"
              )
              render Components::Button.new(
                "Delete",
                to: hyper_kitten_meow.admin_tag_path(tag),
                method: :delete,
                variant: :danger,
                size: :sm,
                icon: "trash-2"
              )
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
