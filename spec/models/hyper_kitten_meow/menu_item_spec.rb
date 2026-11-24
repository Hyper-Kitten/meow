require "rails_helper"

RSpec.describe HyperKittenMeow::MenuItem, type: :model do
  it "links to a page or a URL, not both" do
    item = build(:menu_item, page: create(:page))

    expect(item).not_to be_valid
    expect(item.errors[:base]).to include("Link to a page or a URL, not both")
  end

  it "needs a page or a URL" do
    item = build(:menu_item, url: nil)

    expect(item).not_to be_valid
    expect(item.errors[:base]).to include("Choose a page or enter a URL")
  end

  it "requires a label for a URL but not for a page" do
    expect(build(:menu_item, label: " ")).not_to be_valid
    expect(build(:menu_item, :for_page)).to be_valid
  end

  it "accepts paths and http(s) URLs" do
    ["/news", "/", "https://shop.example.org", "HTTP://example.org/a?b=c"].each do |url|
      expect(build(:menu_item, url: url)).to be_valid, url
    end
  end

  it "rejects other schemes and protocol-relative URLs" do
    ["javascript:alert(1)", "news", "//evil.example", "mailto:a@b.c", "data:text/html,hi"].each do |url|
      item = build(:menu_item, url: url)
      expect(item).not_to be_valid, url
      expect(item.errors[:url]).to be_present
    end
  end

  it "strips whitespace from the label and URL" do
    item = build(:menu_item, label: "  Shop ", url: " /shop ")

    expect(item).to have_attributes(label: "Shop", url: "/shop")
  end

  it "keeps the parent in the same menu" do
    parent = create(:menu_item, menu: create(:menu, key: "footer"))
    item = build(:menu_item, parent: parent)

    expect(item).not_to be_valid
    expect(item.errors[:parent]).to include("must be in the same menu")
  end

  it "can't be its own ancestor" do
    menu = create(:menu)
    parent = create(:menu_item, menu: menu)
    child = create(:menu_item, menu: menu, parent: parent)
    parent.parent = child

    expect(parent).not_to be_valid
    expect(parent.errors[:parent]).to be_present
  end

  it "is flagged when its page is deleted" do
    item = create(:menu_item, :for_page)
    item.page.destroy

    item.reload
    expect(item.page_deleted?).to be(true)
    expect(item).not_to be_valid
    expect(item.errors[:base].first).to match(/page was deleted/)
  end
end
