# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Users::Index < Views::Admin::Base
    include Phlex::Rails::Helpers::ButtonTo

    def initialize(users:, pagy:)
      @users = users
      @pagy = pagy
    end

    def view_template
      section(class: "users") do
        render Components::PageHeader.new(title: "Users") do
          render Components::LinkButton.new(hyper_kitten_meow.new_admin_user_path, "Add New")
        end

        render Components::Table.new(collection: @users, tr: {class: "user"}) do |t|
          t.column "Name", method_name: :name
          t.column "Email", method_name: :email
          t.column "Manage" do |user|
            render Components::LinkButton.new(
              hyper_kitten_meow.edit_admin_user_path(user),
              "Edit",
              scheme: :sm_outline_info
            )
            button_to "Delete",
              hyper_kitten_meow.admin_user_path(user),
              method: :delete,
              class: "btn btn-sm btn-outline-danger",
              form_class: "d-inline"
          end
          t.footer do
            render Components::Pagination.new(pagy: @pagy)
          end
        end
      end
    end
  end
end
