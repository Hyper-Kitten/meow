require "rails_helper"

RSpec.describe HyperKittenMeow::Menu, type: :model do
  before { HyperKittenMeow::Current.reset }

  let(:menu) { create(:menu, key: "primary") }

  def fetch_fresh(key = :primary)
    HyperKittenMeow::Current.reset
    described_class.fetch(key)
  end

  describe ".fetch" do
    it "raises for a menu the app doesn't declare" do
      expect { described_class.fetch(:sidebar) }.to raise_error(ArgumentError, /No menu :sidebar/)
    end

    it "returns an empty tree for a declared menu with no row yet" do
      tree = described_class.fetch(:footer)

      expect(tree.key).to eq(:footer)
      expect(tree.items).to eq([])
      expect(described_class.count).to eq(0)
    end

    it "builds a frozen tree in position order with labels and paths worked out" do
      programs = create(:menu_item, menu: menu, label: "Programs", url: "/programs", position: 1)
      create(:menu_item, menu: menu, label: "Shop", url: "https://shop.example.org", position: 2)
      create(:menu_item, menu: menu, label: "Visit", url: "/visit", position: 0)
      page = create(:page, title: "Star Parties", published: true)
      create(:menu_item, :for_page, menu: menu, page: page, parent: programs, position: 0)

      tree = fetch_fresh

      expect(tree.items.map(&:label)).to eq(["Visit", "Programs", "Shop"])
      star_parties = tree.items[1].children.first
      expect(star_parties).to have_attributes(label: "Star Parties", path: "/pages/star-parties", page_id: page.id, external?: false)
      expect(tree.items[2].external?).to be(true)
      expect(tree.items[0].children?).to be(false)
      expect(tree).to be_frozen
      expect(tree.items).to be_frozen
      expect(tree.items[1].children).to be_frozen
    end

    it "leaves out items for unpublished or deleted pages, with everything under them" do
      draft = create(:page, title: "Draft")
      parent = create(:menu_item, :for_page, menu: menu, page: draft)
      create(:menu_item, menu: menu, parent: parent, label: "Under the draft")
      gone = create(:page, published: true)
      create(:menu_item, :for_page, menu: menu, page: gone)
      gone.destroy
      create(:menu_item, menu: menu, label: "Kept")

      expect(fetch_fresh.items.map(&:label)).to eq(["Kept"])
    end

    it "leaves out items deeper than the declared depth" do
      footer = create(:menu, key: "footer")
      parent = create(:menu_item, menu: footer, label: "Top")
      create(:menu_item, menu: footer, parent: parent, label: "Too deep")

      tree = fetch_fresh(:footer)

      expect(tree.items.map(&:label)).to eq(["Top"])
      expect(tree.items.first.children).to eq([])
    end

    it "memoises the tree for the rest of the request" do
      create(:menu_item, menu: menu)
      described_class.fetch(:primary)

      queries = 0
      counter = ->(*) { queries += 1 }
      tree = ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { described_class.fetch(:primary) }

      expect(queries).to eq(0)
      expect(tree).to equal(described_class.fetch(:primary))
    end

    context "with a cache store" do
      let(:cache) { ActiveSupport::Cache::MemoryStore.new }

      before { allow(Rails).to receive(:cache).and_return(cache) }

      it "serves the cached tree until something touches the menu" do
        item = create(:menu_item, menu: menu, label: "Before")
        expect(fetch_fresh.items.first.label).to eq("Before")

        item.update_column(:label, "Sneaky")
        expect(fetch_fresh.items.first.label).to eq("Before")

        item.update!(label: "After")
        expect(fetch_fresh.items.first.label).to eq("After")
      end

      it "rebuilds when a linked page is renamed, unpublished or deleted" do
        page = create(:page, title: "Old", published: true)
        create(:menu_item, :for_page, menu: menu, page: page)
        expect(fetch_fresh.items.first.label).to eq("Old")

        travel 1.second do
          page.update!(title: "New")
          expect(fetch_fresh.items.first.label).to eq("New")
        end

        travel 2.seconds do
          page.update!(published: false)
          expect(fetch_fresh.items).to be_empty
        end

        travel 3.seconds do
          page.update!(published: true)
          expect(fetch_fresh.items).not_to be_empty
        end

        travel 4.seconds do
          page.destroy
          expect(fetch_fresh.items).to be_empty
        end
      end
    end
  end

  describe "Tree#trail_to" do
    let(:tree) do
      programs = create(:menu_item, menu: menu, label: "Programs", url: "/programs", position: 0)
      create(:menu_item, menu: menu, parent: programs, label: "Star Parties", url: "/programs/star-parties")
      create(:menu_item, menu: menu, label: "News", url: "/news", position: 1)
      fetch_fresh
    end

    it "returns the deepest match with its ancestors first" do
      expect(tree.trail_to("/programs/star-parties").map(&:label)).to eq(["Programs", "Star Parties"])
      expect(tree.trail_to("/programs").map(&:label)).to eq(["Programs"])
    end

    it "ignores the query string and a trailing slash" do
      expect(tree.trail_to("/news/?page=2").map(&:label)).to eq(["News"])
    end

    it "returns an empty array when nothing matches" do
      expect(tree.trail_to("/elsewhere")).to eq([])
    end

    it "walks every item depth-first" do
      expect(tree.each_item.map(&:label)).to eq(["Programs", "Star Parties", "News"])
    end
  end

  describe "#replace_tree" do
    let(:page) { create(:page, title: "Star Parties", published: true) }

    it "creates new rows, nesting them by their temporary keys" do
      saved = menu.replace_tree(
        "-1" => {label: "Programs", link_type: "url", url: "/programs", position: "0"},
        "-2" => {parent_key: "-1", link_type: "page", page_id: page.id.to_s, url: "/ignored", position: "0"},
        "-3" => {label: "News", link_type: "url", url: "/news", page_id: page.id.to_s, position: "1"}
      )

      expect(saved).to be(true)
      programs = menu.items.find_by!(label: "Programs")
      expect(programs.children.map(&:page)).to eq([page])
      expect(programs.children.first.url).to be_nil
      expect(menu.items.find_by!(label: "News").page_id).to be_nil
      expect(menu.items.where(parent_id: nil).map(&:position)).to eq([0, 1])
    end

    it "updates, moves, renumbers and deletes existing rows" do
      a = create(:menu_item, menu: menu, label: "A", position: 0)
      b = create(:menu_item, menu: menu, label: "B", position: 1)
      c = create(:menu_item, menu: menu, label: "C", parent: a, position: 0)
      d = create(:menu_item, menu: menu, label: "D", position: 2)
      other = create(:menu_item, menu: create(:menu, key: "footer"))

      saved = menu.replace_tree(
        b.id.to_s => {id: b.id, label: "B2", link_type: "url", url: "/b", position: "5"},
        c.id.to_s => {id: c.id, parent_key: b.id.to_s, label: "C", link_type: "url", url: "/c", position: "0"},
        a.id.to_s => {id: a.id, label: "A", link_type: "url", url: "/a", position: "9"},
        d.id.to_s => {id: d.id, label: "D", url: "/d", _destroy: "1"}
      )

      expect(saved).to be(true)
      expect(menu.items.where(parent_id: nil).map(&:label)).to eq(["B2", "A"])
      expect(menu.items.where(parent_id: nil).map(&:position)).to eq([0, 1])
      expect(c.reload.parent).to eq(b)
      expect(HyperKittenMeow::MenuItem.exists?(d.id)).to be(false)
      expect(HyperKittenMeow::MenuItem.exists?(other.id)).to be(true)
    end

    it "deletes rows left out of the post, with their children" do
      parent = create(:menu_item, menu: menu)
      create(:menu_item, menu: menu, parent: parent)

      expect(menu.replace_tree({})).to be(true)
      expect(menu.items.count).to eq(0)
    end

    it "touches the menu once" do
      menu.update_column(:updated_at, 1.day.ago)

      expect { menu.replace_tree("-1" => {label: "A", link_type: "url", url: "/a"}) }
        .to change { menu.reload.updated_at }
    end

    it "rejects a tree deeper than the menu allows and saves nothing" do
      existing = create(:menu_item, menu: menu, label: "Keep me")

      saved = menu.replace_tree(
        "-1" => {label: "One", link_type: "url", url: "/1"},
        "-2" => {parent_key: "-1", label: "Two", link_type: "url", url: "/2"},
        "-3" => {parent_key: "-2", label: "Three", link_type: "url", url: "/3"}
      )

      expect(saved).to be(false)
      expect(menu.tree_errors).to eq(["Three: Too deep for this menu"])
      expect(menu.items.reload).to eq([existing])
    end

    it "reports row errors by label and keeps the posted tree for the editor" do
      saved = menu.replace_tree(
        "-1" => {label: "Shop", link_type: "url", url: ""},
        "-2" => {parent_key: "-1", label: "Child", link_type: "url", url: "/child"}
      )

      expect(saved).to be(false)
      expect(menu.tree_errors).to include("Shop: Label is required for a URL").or include("Shop: Choose a page or enter a URL")
      expect(menu.editor_rows.map(&:key)).to eq(["-1"])
      expect(menu.editor_rows.first.children.map(&:key)).to eq(["-2"])
    end

    it "rejects a parent key that isn't in the post" do
      expect(menu.replace_tree("-1" => {parent_key: "-9", label: "Orphan", link_type: "url", url: "/o"})).to be(false)
      expect(menu.tree_errors).to eq(["Orphan: The item it was under was removed"])
    end

    it "rejects a loop" do
      saved = menu.replace_tree(
        "-1" => {parent_key: "-2", label: "A", link_type: "url", url: "/a"},
        "-2" => {parent_key: "-1", label: "B", link_type: "url", url: "/b"}
      )

      expect(saved).to be(false)
      expect(menu.tree_errors).to include("A: Can't be under itself")
    end

    it "can't take over another menu's items" do
      other = create(:menu_item, menu: create(:menu, key: "footer"), label: "Footer link")

      menu.replace_tree(other.id.to_s => {id: other.id, label: "Hijacked", link_type: "url", url: "/x"})

      expect(other.reload.label).to eq("Footer link")
      expect(menu.items.pluck(:label)).to eq(["Hijacked"])
    end
  end
end
