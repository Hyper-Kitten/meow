# frozen_string_literal: true

module HyperKittenMeow
  module Views::Admin::Users::Concerns::UserForm
    def render_user_form(user, url:, method:, cancel_path:)
      render Components::Form.new(model: user, url: url, method: method) do |f|
        f.text_field :name, required: true
        f.email_field :email, required: true
        f.password_field :password
        f.password_field :password_confirmation

        div(class: "mw-form-actions") do
          render Components::LinkButton.new(cancel_path, "Cancel", scheme: :ghost)
          f.submit
        end
      end
    end
  end
end
