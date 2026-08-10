# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Views::Admin::Base, type: :view do
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
      # Load the yaml first: storing into an uninitialized backend is discarded
      # when the first lookup loads the translation files over it.
      I18n.backend.load_translations
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
