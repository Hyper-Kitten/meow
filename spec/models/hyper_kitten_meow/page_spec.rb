require 'rails_helper'

RSpec.describe HyperKittenMeow::Page, type: :model do
  it_behaves_like "a sluggable" do
    subject { build(:page, title: nil, slug: nil) }
  end

  describe "#slug" do
    it "is created automatically from the title if not provided" do
      page = create(:page, title: "My Title")

      expect(page.slug).to eq('my-title')
    end

    it "is created user input if provided" do
      page = create(:page, title: "My Title", slug: "my slug")

      expect(page.slug).to eq('my-slug')
    end
  end

  describe "#published" do
    it "is false by default" do
      page = build(:page)

      expect(page.published?).to be_falsey
    end
  end

  describe ".published" do
    it "returns only published pages" do
      published_page = create(:page, published: true)
      unpublished_page = create(:page, published: false)

      expect(HyperKittenMeow::Page.published).to eq([published_page])
    end
  end

  describe "#published_at" do
    it "is null by default" do
      page = build(:page)

      expect(page.published_at).to be_nil
    end

    it "is set to the current date when the page is published" do
      time = Time.current
      travel_to time do
        page = create(:page)

        page.published = true
        page.save!

        expect(page.published_at).to be_within(1.second).of(time)
      end
    end

    it "only updates when the published attribute changes" do
      page = create(:page, published: true)

      page.published_at = Date.today - 1.day
      page.save!

      page.published = true
      page.save!

      expect(page.published_at).to eq(Date.today - 1.day)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      page = build(:page, slug: 'my-slug')

      expect(page.to_param).to eq('my-slug')
    end
  end
end
