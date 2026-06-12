# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Base < Views::Base
    include Phlex::Rails::Helpers::Flash

    register_value_helper :logged_in?
    register_value_helper :current_user

    def page_title
      "#{t('title')} - Admin"
    end

    def render_chrome?
      true
    end

    def head_content
      stylesheet_link_tag "https://cdn.quilljs.com/1.3.6/quill.snow.css"
      javascript_importmap_tags("hyper_kitten_meow/application")
    end

    def around_template(&block)
      super do
        if render_chrome?
          div(class: "mw-shell") do
            render_sidebar
            div(class: "mw-content") do
              div(class: "mw-content__inner") do
                render Components::Flash.new(flash: flash)
                yield
              end
            end
          end
        else
          yield
        end
      end
    end

    private

    def render_sidebar
      render Components::Sidebar.new do |s|
        next unless logged_in?

        s.section "Manage"
        s.menu do
          s.item "Posts", hyper_kitten_meow.admin_posts_path, icon: "newspaper"
          s.item "Pages", hyper_kitten_meow.admin_pages_path, icon: "file-text"
          s.item "Tags",  hyper_kitten_meow.admin_tags_path,  icon: "tag"
          s.item "Users", hyper_kitten_meow.admin_users_path, icon: "users"
        end
        s.user_chip(
          name: current_user.name,
          logout_path: hyper_kitten_meow.admin_logout_path,
          logout_title: t("sessions.destroy")
        )
      end
    end
  end
end
