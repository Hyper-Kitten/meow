# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::FirstUsers::New < Views::Admin::Base
    def initialize(user:)
      @user = user
    end

    def render_chrome?
      false
    end

    def view_template
      div(class: "mw-setup") do
        div(class: "mw-setup__inner") do
          div(class: "mw-setup__brand") { render Components::Wordmark.new }

          div(class: "mw-setup__card new-user") do
            span(class: "ds-eyebrow") { "First run" }
            h2(class: "ds-h2") { "Create your account" }
            p(class: "mw-setup__lede") { "Set up the first admin user to get started." }

            render Components::Form.new(model: @user, url: hyper_kitten_meow.admin_first_users_path, method: :post) do |f|
              f.text_field :name, required: true
              f.email_field :email, required: true
              f.password_field :password, required: true
              f.password_field :password_confirmation, required: true

              f.submit
            end
          end
        end
      end
    end
  end
end
