# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Users::Index < Views::Admin::Base
    def initialize(users:, pagy:)
      @users = users
      @pagy = pagy
    end

    def view_template
      section(class: "users") do
        render Components::PageHeader.new(title: "Users", eyebrow: "#{@pagy.count} accounts") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_user_path, "Add New", icon: "plus")
        end

        render Components::Table.new(collection: @users, tr: {class: "user"}) do |t|
          t.column "Name", class: "cell-title", method_name: :name
          t.column "Email", class: "cell-mono", method_name: :email
          t.column "", header_options: {class: "col-actions"}, class: "col-actions" do |user|
            render Components::ButtonGroup.new(align: :end) do
              render Components::LinkButton.new(
                hyper_kitten_meow.edit_admin_user_path(user),
                "Edit",
                scheme: :sm_outline_info,
                icon: "pen-line"
              )
              render Components::Button.new(
                "Delete",
                to: hyper_kitten_meow.admin_user_path(user),
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
