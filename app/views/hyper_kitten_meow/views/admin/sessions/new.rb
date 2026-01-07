# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Sessions::New < Views::Admin::Base
    def view_template
      section(class: "d-flex justify-content-center") do
        div(style: "width: 300px;") do
          h2(class: "mb-4") { "Login" }

          render Components::Form.new(url: hyper_kitten_meow.admin_login_path, scope: :session, method: :post) do |f|
            f.email_field :email, required: true
            f.password_field :password, required: true
            f.submit t("sessions.submit")
          end
        end
      end
    end
  end
end
