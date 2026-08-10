# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Components::Wordmark, type: :view do
  describe "brand text" do
    it "uses the site title so the sidebar and the browser tab agree" do
      render described_class.new

      expect(rendered).to have_css("span.mw-wordmark__text", text: "#{I18n.t('title')}.")
    end

    it "follows the host app's title translation" do
      # Load the yaml first: storing into an uninitialized backend is discarded
      # when the first lookup loads the translation files over it.
      I18n.backend.load_translations
      I18n.backend.store_translations(:en, title: "Susquehanna Footprints")

      render described_class.new

      expect(rendered).to have_css("span.mw-wordmark__text", text: "Susquehanna Footprints.")
    ensure
      I18n.backend.reload!
    end

    it "accepts text passed directly" do
      render described_class.new(text: "Hyper Kitten")

      expect(rendered).to have_css("span.mw-wordmark__text", text: "Hyper Kitten.")
    end

    it "describes the mark with the brand text" do
      render described_class.new(text: "Hyper Kitten")

      expect(rendered).to have_css("img[alt='Hyper Kitten']", visible: :all)
    end

    it "omits the text when only the mark is wanted" do
      render described_class.new(mark_only: true)

      expect(rendered).to have_no_css("span.mw-wordmark__text")
      expect(rendered).to have_css("img", visible: :all)
    end
  end

  describe "the mark" do
    it "defaults to the engine's mark" do
      render described_class.new

      expect(rendered).to have_css("img[src*='meow-mark']", visible: :all)
    end

    it "uses the light mark on a dark background" do
      render described_class.new(light: true)

      expect(rendered).to have_css("span.mw-wordmark.mw-wordmark--light")
      expect(rendered).to have_css("img[src*='meow-mark-light']", visible: :all)
    end

    it "accepts a host app's own mark" do
      render described_class.new(mark: "hyper_kitten_meow/meow-mark-orange.svg")

      expect(rendered).to have_css("img[src*='meow-mark-orange']", visible: :all)
    end

    it "renders text alone when the mark is declined" do
      render described_class.new(mark: false, text: "Susquehanna Footprints")

      expect(rendered).to have_no_css("img", visible: :all)
      expect(rendered).to have_css("span.mw-wordmark__text", text: "Susquehanna Footprints.")
    end
  end
end
