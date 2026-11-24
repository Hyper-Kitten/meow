require "rails_helper"

RSpec.feature "Admin menus", type: :feature do
  scenario "the index lists the declared menus" do
    create_user_and_login
    menu = create(:menu, key: "primary")
    create_list(:menu_item, 2, menu: menu)

    click_on "Menus"

    expect(page).to have_css("h1", text: "Menus")
    within("tr", text: "Primary menu") do
      expect(page).to have_text("primary")
      expect(page).to have_css("td", text: "2", exact_text: true)
      click_on "Edit"
    end
    expect(page).to have_css("h1", text: "Primary menu")
    expect(page).to have_text("Up to 2 levels · 2 items")
  end

  scenario "an unknown menu is not found" do
    create_user_and_login

    visit hyper_kitten_meow.edit_admin_menu_path("sidebar")

    expect(page.status_code).to eq(404)
  end

  scenario "the editor shows targets and badges" do
    create_user_and_login
    menu = create(:menu, key: "primary")
    programs = create(:menu_item, menu: menu, label: "Programs", url: "/programs")
    create(:menu_item, :for_page, menu: menu, parent: programs, page: create(:page, title: "School Groups"))
    create(:menu_item, menu: menu, label: "Shop", url: "https://shop.example.org")

    visit hyper_kitten_meow.edit_admin_menu_path("primary")

    within("#menu_item_#{programs.id}_row") do
      expect(page).to have_text("School Groups")
      expect(page).to have_text("Hidden · page is a draft")
    end
    expect(page).to have_text("https://shop.example.org")
  end

  scenario "an editor builds a menu and saves it", js: true do
    create_user_and_login
    create(:page, title: "Star Parties", published: true)
    create(:menu_item, menu: create(:menu, key: "primary"), label: "Programs", url: "/programs")

    visit hyper_kitten_meow.edit_admin_menu_path("primary")
    expect(page).not_to have_text(/unsaved changes/i)

    within(".mw-menu-editor .mw-pageheader") { click_on "Add Item" }
    new_row = all("li.mw-menu-item").last
    within(new_row) do
      select "Star Parties", from: "Page"
      expect(find("[data-role='label']")).to have_text("Star Parties")
      click_on "Move into the item above"
    end
    expect(page).to have_text(/unsaved changes/i)

    within(".mw-menu-editor .mw-pageheader") { click_on "Add Item" }
    within(all("li.mw-menu-item").last) do
      fill_in "Label", with: "Shop"
      choose "A URL", allow_label_click: true
      fill_in "URL", with: "https://shop.example.org"
    end

    click_on "Save Menu"

    expect(page).to have_text("Primary menu saved.")
    tree = HyperKittenMeow::Menu.fetch(:primary)
    expect(tree.items.map(&:label)).to eq(["Programs", "Shop"])
    expect(tree.items.first.children.map(&:label)).to eq(["Star Parties"])
    expect(tree.items.last.external?).to be(true)
  end

  scenario "an editor outdents and removes items", js: true do
    create_user_and_login
    menu = create(:menu, key: "primary")
    programs = create(:menu_item, menu: menu, label: "Programs", url: "/programs", position: 0)
    star = create(:menu_item, menu: menu, label: "Star Parties", url: "/star", parent: programs, position: 0)
    create(:menu_item, menu: menu, label: "News", url: "/news", position: 1)

    visit hyper_kitten_meow.edit_admin_menu_path("primary")

    within("#menu_item_#{star.id}_row") { click_on "Move out a level" }
    within("li.mw-menu-item", text: "News") { click_on "Remove" }
    click_on "Save Menu"

    expect(page).to have_text("Primary menu saved.")
    expect(menu.items.reload.map { |item| [item.label, item.parent_id] })
      .to eq([["Programs", nil], ["Star Parties", nil]])
  end

  scenario "errors re-render the editor with the posted tree", js: true do
    create_user_and_login
    create(:menu, key: "primary")

    visit hyper_kitten_meow.edit_admin_menu_path("primary")
    expect(page).to have_text("No items yet.")
    within(".mw-menu-empty") { click_on "Add Item" }
    within(all("li.mw-menu-item").last) do
      choose "A URL", allow_label_click: true
      fill_in "URL", with: "javascript:alert(1)"
    end
    click_on "Save Menu"

    expect(page).to have_text("The menu wasn't saved.")
    within("li.mw-menu-item") do
      expect(page).to have_field("URL", with: "javascript:alert(1)")
      expect(page).to have_text("URL must start with / or http:// or https://")
    end
    expect(HyperKittenMeow::MenuItem.count).to eq(0)

    dismiss_confirm("Leave without saving your menu changes?") { click_on "Posts" }
    expect(page).to have_css("h1", text: "Primary menu")
  end

  scenario "a save from an outdated copy is refused", js: true do
    create_user_and_login
    menu = create(:menu, key: "primary")
    create(:menu_item, menu: menu, label: "Mine", url: "/mine")

    visit hyper_kitten_meow.edit_admin_menu_path("primary")
    travel 1.second do
      create(:menu_item, menu: menu, label: "Theirs", url: "/theirs")
    end
    click_on "Save Menu"

    expect(page).to have_text("Someone else saved this menu after you opened it")
    expect(menu.items.reload.map(&:label)).to contain_exactly("Mine", "Theirs")

    click_on "Save Menu"
    expect(page).to have_text("Primary menu saved.")
    expect(menu.items.reload.map(&:label)).to eq(["Mine"])
  end
end
