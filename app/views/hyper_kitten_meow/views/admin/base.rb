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
      stylesheet_link_tag "lexxy"
      javascript_importmap_tags("hyper_kitten_meow/application")
    end

    def sidebar_brand
      nil
    end

    def sidebar_class
      return Components::AdminSidebar unless Object.const_defined?("Meow::Sidebar")

      ::Meow::Sidebar.tap do |klass|
        unless klass < Components::AdminSidebar
          raise TypeError, "Meow::Sidebar must subclass " \
                           "HyperKittenMeow::Components::AdminSidebar, got #{klass.superclass}"
        end
      end
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
      render sidebar_class.new(brand: sidebar_brand) do |s|
        next unless logged_in?

        s.default_menu
        s.user_chip(
          name: current_user.name,
          logout_path: hyper_kitten_meow.admin_logout_path,
          logout_title: t("sessions.destroy")
        )
      end
    end
  end
end
