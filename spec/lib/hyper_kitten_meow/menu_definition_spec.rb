require "rails_helper"

RSpec.describe HyperKittenMeow::MenuDefinition do
  describe ".from_config" do
    it "normalises keys and fills in defaults" do
      menus = described_class.from_config({"primary" => {depth: 2, label: "Main navigation"}, :footer => {}})

      expect(menus.keys).to eq([:primary, :footer])
      expect(menus[:primary]).to have_attributes(depth: 2, label: "Main navigation")
      expect(menus[:footer]).to have_attributes(depth: 1, label: "Footer menu")
    end

    it "reads string-keyed options, as loaded from YAML" do
      menus = described_class.from_config({"primary" => {"depth" => 2, "label" => "Main"}})

      expect(menus[:primary]).to have_attributes(depth: 2, label: "Main")
    end

    it "raises on an unknown option" do
      expect { described_class.from_config({primary: {dept: 2}}) }
        .to raise_error(ArgumentError, /unknown option.*:dept/)
    end

    it "raises on a depth below 1" do
      expect { described_class.from_config({primary: {depth: 0}}) }
        .to raise_error(ArgumentError, /depth of 1 or more/)
    end
  end

  describe "HyperKittenMeow.page_path" do
    it "uses the app's page_path route helper by default" do
      page = build(:page, slug: "star-parties")

      expect(HyperKittenMeow.page_path(page)).to eq("/pages/star-parties")
    end

    it "uses the configured resolver when one is set" do
      allow(HyperKittenMeow.config).to receive(:page_path).and_return(->(page) { "/#{page.slug}" })

      expect(HyperKittenMeow.page_path(build(:page, slug: "about"))).to eq("/about")
    end
  end
end
