require 'rails_helper'

RSpec.describe HyperKittenMeow::Post, type: :model do
  it_behaves_like "a sluggable" do
    subject { build(:post, title: nil, slug: nil) }
  end

  describe "#slug" do
    it "is created automatically from the title if not provided" do
      post = create(:post, title: "My Title")

      expect(post.slug).to eq('my-title')
    end

    it "is created user input if provided" do
      post = create(:post, title: "My Title", slug: "my slug")

      expect(post.slug).to eq('my-slug')
    end
  end

  describe "#css_classes" do
    it "returns 'not-published' if the article is not published" do
      post = build(:post, published: false)

      expect(post.css_classes).to eq("not-published")
    end

    it "returns 'published' if the article is published" do
      post = build(:post, published: true)

      expect(post.css_classes).to eq("published")
    end
  end

  describe "#published" do
    it "is false by default" do
      post = build(:post)

      expect(post.published?).to be_falsey
    end
  end

  describe ".sorted_by_published_date" do
    it "finds all the published posts ordered by date with the tag" do
      tagged_older_post = create(:post, published: true)
      tagged_newer_post = create(:post, published: true)

      tagged_older_post.published_at = Time.now - 2.hours
      tagged_newer_post.published_at = Time.now
      tagged_older_post.save!
      tagged_newer_post.save!

      expect(HyperKittenMeow::Post.sorted_by_published_date).
        to eq([tagged_newer_post, tagged_older_post])
    end
  end

  describe ".published" do
    it "returns only published posts" do
      published_post = create(:post, published: true)
      unpublished_post = create(:post, published: false)

      expect(HyperKittenMeow::Post.published).to eq([published_post])
    end
  end

  describe "#published_at" do
    it "is null by default" do
      post = build(:post)

      expect(post.published_at).to be_nil
    end

    it "is set to the current date when the post is published" do
      time = Time.current
      travel_to time do
        post = create(:post)

        post.published = true
        post.save!

        expect(post.published_at).to be_within(1.second).of(time)
      end
    end

    it "only updates when the published attribute changes" do
      post = create(:post, published: true)

      post.published_at = Date.today - 1.day
      post.save!

      post.published = true
      post.save!

      expect(post.published_at).to eq(Date.today - 1.day)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      post = build(:post, slug: 'my-slug')

      expect(post.to_param).to eq('my-slug')
    end
  end
end
