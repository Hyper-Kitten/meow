# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Components::Sidebar, type: :view do
  describe "the brand" do
    it "renders the engine wordmark by default" do
      render described_class.new

      expect(rendered).to have_css("nav.mw-sidebar div.mw-sidebar__brand span.mw-wordmark")
      expect(rendered).to have_css("div.mw-sidebar__brand img[src*='meow-mark']", visible: :all)
    end

    it "renders the light wordmark on a dark sidebar" do
      render described_class.new(light: true)

      expect(rendered).to have_css("div.mw-sidebar__brand span.mw-wordmark--light")
    end

    it "renders a host-supplied component instead" do
      brand = HyperKittenMeow::Components::Wordmark.new(text: "Susquehanna Footprints", mark: false)

      render described_class.new(brand: brand)

      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Susquehanna Footprints.")
      expect(rendered).to have_no_css("div.mw-sidebar__brand img", visible: :all)
    end

    it "renders a host-supplied string" do
      render described_class.new(brand: "Susquehanna Footprints")

      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Susquehanna Footprints")
      expect(rendered).to have_no_css("div.mw-sidebar__brand span.mw-wordmark")
    end
  end

  describe "the menu" do
    it "still renders items alongside a replaced brand" do
      render described_class.new(brand: "Footprints") { |s|
        s.section "Manage"
        s.menu { s.item "Episodes", "/admin/episodes", icon: "mic" }
      }

      expect(rendered).to have_css("div.mw-sidebar__brand", text: "Footprints")
      expect(rendered).to have_css("span.mw-sidebar__section", text: "Manage")
      expect(rendered).to have_css("div.mw-nav a.mw-nav__item[href='/admin/episodes']", text: "Episodes")
      expect(rendered).to have_css("a.mw-nav__item svg.lucide-mic", visible: :all)
    end
  end
end
