# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Views::Admin::Base, type: :view do
  describe "#sidebar_class" do
    it "renders the engine's sections when the host app supplies no sidebar" do
      routes = HyperKittenMeow::Engine.routes.url_helpers
      view = described_class.new
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(double(name: "Ada Lovelace"))

      render view

      expect(rendered).to have_css("span.mw-sidebar__section", text: "Manage")
      expect(rendered).to have_css("a.mw-nav__item[href='#{routes.admin_posts_path}']", text: "Posts")
      expect(rendered).to have_css("a.mw-nav__item[href='#{routes.admin_users_path}']", text: "Users")
    end

    it "renders a host app's Meow::Sidebar on screens it never subclasses" do
      # Stands in for one of the engine's own screens, which subclass
      # Views::Admin::Base directly and so are out of the host app's reach.
      screen = Class.new(described_class)
      routes = HyperKittenMeow::Engine.routes.url_helpers
      stub_const("Meow::Sidebar", Class.new(HyperKittenMeow::Components::AdminSidebar) {
        def default_menu
          super
          menu { item "Episodes", "/admin/episodes", icon: "mic" }
        end
      })
      view = screen.new
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(double(name: "Ada Lovelace"))

      render view

      expect(rendered).to have_css("a.mw-nav__item[href='#{routes.admin_posts_path}']", text: "Posts")
      expect(rendered).to have_css("a.mw-nav__item[href='/admin/episodes']", text: "Episodes")
    end

    it "drops the engine's sections when the host app's sidebar does not call super" do
      routes = HyperKittenMeow::Engine.routes.url_helpers
      stub_const("Meow::Sidebar", Class.new(HyperKittenMeow::Components::AdminSidebar) {
        def default_menu
          menu { item "Episodes", "/admin/episodes", icon: "mic" }
        end
      })
      view = described_class.new
      allow(view).to receive(:logged_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(double(name: "Ada Lovelace"))

      render view

      expect(rendered).to have_css("a.mw-nav__item[href='/admin/episodes']", text: "Episodes")
      expect(rendered).to have_no_css("a.mw-nav__item[href='#{routes.admin_posts_path}']")
      expect(rendered).to have_css("div.mw-userchip__name", text: "Ada Lovelace")
    end

    it "says so when Meow::Sidebar is some unrelated class the host app already had" do
      stub_const("Meow::Sidebar", Class.new)

      expect { described_class.new.sidebar_class }
        .to raise_error(TypeError, /must subclass HyperKittenMeow::Components::AdminSidebar/)
    end

    it "says so when Meow::Sidebar is a plain sidebar, which has no default_menu to render" do
      stub_const("Meow::Sidebar", Class.new(HyperKittenMeow::Components::Sidebar))

      expect { described_class.new.sidebar_class }
        .to raise_error(TypeError, /must subclass HyperKittenMeow::Components::AdminSidebar/)
    end
  end

  describe "#sidebar_brand" do
    it "leaves the engine wordmark in place when the host app has no brand of its own" do
      view = described_class.new
      allow(view).to receive(:logged_in?).and_return(false)

      render view

      expect(rendered).to have_css("div.mw-sidebar__brand span.mw-wordmark")
    end

    it "renders whatever a host app subclass returns" do
      branded = Class.new(described_class) do
        def sidebar_brand
          HyperKittenMeow::Components::Wordmark.new(
            text: "Susquehanna Footprints", mark: false, light: true
          )
        end
      end
      view = branded.new
      allow(view).to receive(:logged_in?).and_return(false)

      render view

      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Susquehanna Footprints.")
      expect(rendered).to have_no_css("div.mw-sidebar__brand img", visible: :all)
    end

    it "brands the browser tab from the same translation the wordmark uses" do
      # Look something up first: storing into an uninitialized backend is
      # discarded when the first lookup loads the translation files over it.
      I18n.t("title")
      I18n.backend.store_translations(:en, title: "Susquehanna Footprints")
      view = described_class.new
      allow(view).to receive(:logged_in?).and_return(false)

      render view

      expect(view.page_title).to eq("Susquehanna Footprints - Admin")
      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Susquehanna Footprints.")
    ensure
      I18n.backend.reload!
    end
  end
end
