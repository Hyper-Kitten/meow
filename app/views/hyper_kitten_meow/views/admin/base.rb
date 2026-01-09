# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Base < Views::Base
    include Phlex::Rails::Helpers::Flash

    register_value_helper :logged_in?
    register_value_helper :current_user

    KEY_TRANSFORMATIONS = {
      "alert" => "warning",
      "error" => "danger",
      "notice" => "info",
      "success" => "success"
    }

    def page_title
      "#{t('title')} - Admin"
    end

    def head_content
      stylesheet_link_tag "https://cdn.quilljs.com/1.3.6/quill.snow.css"
      stylesheet_link_tag "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css"
      javascript_importmap_tags("hyper_kitten_meow/application")
    end

    def around_template(&block)
      super do
        div(class: "container-fluid h-100") do
          div(class: "row h-100") do
            render_sidebar
            div(class: "col-md-9 col-lg-10 mt-3 px-4") do
              render_flash
              yield
            end
          end
        end
      end
    end

    private

    def render_flash
      return unless flash.any?

      flashes = flash.to_hash.slice("alert", "error", "notice", "success")
      user_flashes = flashes.transform_keys { |key| KEY_TRANSFORMATIONS[key] }
      user_flashes.each do |key, value|
        div(class: "alert alert-#{key}") { value }
      end
    end

    def render_sidebar
      nav(class: "col-md-3 col-lg-2 d-md-block sidebar bg-dark text-white d-flex flex-column") do
        h3(class: "mb-3 mt-3") { t("title") }
        hr
        if logged_in?
          ul(class: "nav nav-pills flex-column mb-auto") do
            li(class: "nav-item") { link_to "Posts", hyper_kitten_meow.admin_posts_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Pages", hyper_kitten_meow.admin_pages_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Tags", hyper_kitten_meow.admin_tags_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Users", hyper_kitten_meow.admin_users_path, class: "nav-link text-white" }
          end
          hr
          render_user_menu
        end
      end
    end

    def render_user_menu
      link_to "#",
        class: "nav-link d-flex align-items-center text-white text-decoration-none dropdown-toggle",
        data: {bs_toggle: "dropdown"},
        aria_expanded: false do
        strong { current_user.name }
      end
      ul(class: "dropdown-menu dropdown-menu-dark text-small shadow") do
        li { link_to t("sessions.destroy"), hyper_kitten_meow.admin_logout_path, class: "dropdown-item" }
      end
    end
  end
end
