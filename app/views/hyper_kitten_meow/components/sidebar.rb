# frozen_string_literal: true

module HyperKittenMeow
  class Components::Sidebar < Components::Base
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::Request

    def initialize(light: true)
      @light = light
    end

    def view_template(&block)
      nav(class: "mw-sidebar") do
        div(class: "mw-sidebar__brand") { render Components::Wordmark.new(light: @light) }
        yield(self) if block_given?
      end
    end

    def section(title)
      span(class: "ds-eyebrow mw-sidebar__section") { title }
    end

    def menu(&block)
      div(class: "mw-nav", &block)
    end

    def item(label, path, icon:, active: nil)
      active = request.path.start_with?(path) if active.nil?
      classes = ["mw-nav__item", ("is-active" if active)].compact
      link_to path, class: classes do
        render Components::Icon.new(icon, size: :md)
        plain label
      end
    end

    def user_chip(name:, logout_path:, role: "Admin", logout_title: "Log Out")
      div(class: "mw-sidebar__foot") do
        div(class: "mw-userchip") do
          div(class: "mw-userchip__avatar") { initials(name) }
          div(class: "mw-userchip__meta") do
            div(class: "mw-userchip__name") { name }
            div(class: "mw-userchip__role") { role }
          end
          link_to logout_path, class: "mw-userchip__logout", title: logout_title do
            render Components::Icon.new("log-out", size: :sm)
          end
        end
      end
    end

    private

    def initials(name)
      name.to_s.split.map(&:first).join.upcase
    end
  end
end
