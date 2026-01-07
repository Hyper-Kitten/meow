# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Users::Edit < Views::Admin::Base
    include Views::Admin::Users::Concerns::UserForm

    def initialize(user:)
      @user = user
    end

    def view_template
      section do
        render Components::PageHeader.new(title: "Editing User: #{@user.name}") do
          render Components::LinkButton.new(hyper_kitten_meow.admin_users_path, "Back to Users", scheme: :secondary)
        end

        render_user_form(
          @user,
          url: hyper_kitten_meow.admin_user_path(@user),
          method: :patch,
          cancel_path: hyper_kitten_meow.admin_users_path
        )
      end
    end
  end
end
