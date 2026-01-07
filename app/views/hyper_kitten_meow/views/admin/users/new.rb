# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Users::New < Views::Admin::Base
    include Views::Admin::Users::Concerns::UserForm

    def initialize(user:)
      @user = user
    end

    def view_template
      section(class: "new-user") do
        render Components::PageHeader.new(title: "New User") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_users_path, "Back to Users", scheme: :secondary)
        end

        render_user_form(
          @user,
          url: hyper_kitten_meow.admin_users_path,
          method: :post,
          cancel_path: hyper_kitten_meow.admin_users_path
        )
      end
    end
  end
end
