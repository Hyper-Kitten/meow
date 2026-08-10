# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Components::AdminSidebar, type: :view do
  describe "#default_menu" do
    it "renders the engine's own sections without the caller naming their paths" do
      routes = HyperKittenMeow::Engine.routes.url_helpers

      render described_class.new { |s| s.default_menu }

      expect(rendered).to have_css("span.mw-sidebar__section", text: "Manage")
      expect(rendered).to have_css(
        "div.mw-nav a.mw-nav__item[href='#{routes.admin_posts_path}']", text: "Posts"
      )
      expect(rendered).to have_css(
        "div.mw-nav a.mw-nav__item[href='#{routes.admin_pages_path}']", text: "Pages"
      )
      expect(rendered).to have_css(
        "div.mw-nav a.mw-nav__item[href='#{routes.admin_tags_path}']", text: "Tags"
      )
      expect(rendered).to have_css(
        "div.mw-nav a.mw-nav__item[href='#{routes.admin_users_path}']", text: "Users"
      )
    end

    it "leaves the menu out entirely when the caller does not ask for it" do
      routes = HyperKittenMeow::Engine.routes.url_helpers

      render described_class.new { |s|
        s.menu { s.item "Episodes", "/admin/episodes", icon: "mic" }
      }

      expect(rendered).to have_css("div.mw-nav a.mw-nav__item[href='/admin/episodes']", text: "Episodes")
      expect(rendered).to have_no_css("a.mw-nav__item[href='#{routes.admin_posts_path}']")
      expect(rendered).to have_no_css("span.mw-sidebar__section")
    end

    it "still takes the brand its parent does" do
      routes = HyperKittenMeow::Engine.routes.url_helpers

      render described_class.new(brand: "Susquehanna Footprints") { |s| s.default_menu }

      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Susquehanna Footprints")
      expect(rendered).to have_css("a.mw-nav__item[href='#{routes.admin_posts_path}']")
    end
  end
end
