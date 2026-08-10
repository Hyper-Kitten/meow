# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Components::Icon, type: :view do
  def render_icon(...)
    render described_class.new(...)
    rendered
  end

  describe "resolving names" do
    it "renders an icon that ships with the engine" do
      render_icon("plus")

      expect(rendered).to have_css("span.mw-icon svg.lucide-plus", visible: :all)
    end

    it "renders any icon from the vendored lucide set" do
      render_icon("calendar-days")

      expect(rendered).to have_css("span.mw-icon svg.lucide-calendar-days", visible: :all)
    end

    it "prefers the host app's icon directory over the engine's" do
      render_icon("check")

      expect(rendered).to have_css("span.mw-icon svg.host-check", visible: :all)
      expect(rendered).to have_no_css("svg.lucide-check", visible: :all)
    end

    it "renders an icon that only the host app provides" do
      render_icon("hyper-kitten")

      expect(rendered).to have_css("span.mw-icon svg.hyper-kitten", visible: :all)
    end

    it "strips the leading license comment" do
      render_icon("plus")

      expect(rendered).not_to include("@license")
    end
  end

  describe "names that do not resolve" do
    it "renders nothing for an unknown icon" do
      render_icon("no-such-icon")

      expect(rendered).to be_blank
    end

    it "logs a warning naming the directories it searched" do
      allow(Rails.logger).to receive(:warn)

      render_icon("no-such-icon")

      expect(Rails.logger).to have_received(:warn).with(/no icon named "no-such-icon".*app\/assets\/images\/icons/m)
    end

    it "renders nothing for a name that tries to escape the icon directories" do
      render_icon("../../../config/database")

      expect(rendered).to be_blank
    end

    it "renders nothing for a name with unexpected characters" do
      render_icon("Plus Sign")

      expect(rendered).to be_blank
    end
  end

  describe "sizing" do
    it "applies a size class for a named size" do
      render_icon("plus", size: :sm)

      expect(rendered).to have_css("span.mw-icon.mw-icon--sm", visible: :all)
      expect(rendered).to have_no_css("span[style]", visible: :all)
    end

    it "applies an inline size for a numeric size" do
      render_icon("plus", size: 40)

      expect(rendered).to have_css("span.mw-icon[style*='width: 40px']", visible: :all)
      expect(rendered).to have_no_css("span[class*='mw-icon--']", visible: :all)
    end
  end

  describe "options" do
    it "merges a caller-supplied class and passes other attributes through" do
      render_icon("plus", class: "extra", "aria-hidden": "true")

      expect(rendered).to have_css("span.mw-icon.extra[aria-hidden='true']", visible: :all)
    end
  end
end
