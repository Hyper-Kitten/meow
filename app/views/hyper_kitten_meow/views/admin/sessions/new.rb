# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Sessions::New < Views::Admin::Base
    include Phlex::Rails::Helpers::AssetPath

    def render_chrome?
      false
    end

    def view_template
      div(class: "mw-login") do
        render_aside
        render_form
      end
    end

    private

    def render_aside
      div(class: "mw-login__aside") do
        render Components::Wordmark.new(light: true)

        div do
          span(class: "ds-eyebrow") { "Open-source blogging engine" }
          h1(class: "mw-login__headline") do
            plain "A deliberately "
            em { "boring" }
            plain " place to write."
          end
          p(class: "mw-login__lede") do
            "Posts, pages, tags. No frills, no ceremony — just a fast, readable admin for your Rails blog."
          end
        end

        div(class: "mw-login__footmark") { "=^··^=  HYPER-KITTEN / MEOW" }

        img(
          src: asset_path("hyper_kitten_meow/meow-mark-light.svg"),
          alt: "",
          aria_hidden: "true",
          class: "mw-login__ghost"
        )
      end
    end

    def render_form
      div(class: "mw-login__main") do
        div(class: "mw-login__form") do
          span(class: "ds-eyebrow") { "Admin" }
          h2(class: "ds-h2") { "Sign in to continue" }

          render Components::Flash.new(flash: flash)

          render Components::Form.new(url: hyper_kitten_meow.admin_login_path, scope: :session, method: :post) do |f|
            f.email_field :email, label: "Email", required: true
            f.password_field :password, label: "Password", required: true
            f.submit t("sessions.submit")
          end

          div(class: "mw-login__hint") { "rails hyper_kitten:meow:create_user" }
        end
      end
    end
  end
end
