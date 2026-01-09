require "rails_helper"

RSpec.feature "Admin pages edit", type: :feature do
  scenario "user can edit pages", js: true do
    create_user_and_login
    static_page = create(:page, title: "My Title")

    visit hyper_kitten_meow.edit_admin_page_path(static_page)
    expect(page).to have_content("Editing Page")
    expect(page).to have_field("Title", with: "My Title")

    fill_in "Title", with: "Hello World!"
    select "Test Template", from: "Template"
    within(".content-blocks") do
      fill_in_quill_editor "Test Block", with: "hello"
    end
    fill_in "Slug", with: "my slug"
    check "Published"
    click_on "Update Page"

    expect(page).to have_text("Page was successfully updated.")
    expect(current_path).to eq(hyper_kitten_meow.admin_pages_path)
    expect(page).to have_text("Hello World!")
    expect(page).to have_text("my-slug")
    meow_page = HyperKittenMeow::Page.last
    expect(meow_page.content_blocks.count).to eq(2)
    test_block = meow_page.content_blocks.find_by(name: "test_block")
    expect(test_block.body.to_plain_text).to eq("hello")
    test_block_two = meow_page.content_blocks.find_by(name: "test_block_two")
    expect(test_block_two.body.to_plain_text.to_s).to eq("")
  end

  scenario "user can edit pages with existing content blocks", js: true do
    create_user_and_login
    static_page = create(:page, title: "My Title", template: "TestTemplate")
    static_page.content_blocks.create(name: "Test Block", body: "block content")

    visit hyper_kitten_meow.edit_admin_page_path(static_page)

    expect(page).to have_text("My Title")
    expect(page).to have_text("block content")

    fill_in "Title", with: "Hello World!"
    select "Test Template", from: "Template"
    within(".content-blocks") do
      fill_in_quill_editor "Test Block", with: "hello"
    end
    fill_in "Slug", with: "my slug"
    check "Published"
    click_on "Update Page"

    expect(page).to have_text("Page was successfully updated.")
    expect(current_path).to eq(hyper_kitten_meow.admin_pages_path)
    expect(page).to have_text("Hello World!")
    expect(page).to have_text("my-slug")
    meow_page = HyperKittenMeow::Page.last
    expect(meow_page.content_blocks.count).to eq(1)
    test_block = meow_page.content_blocks.find_by(name: "Test Block")
    expect(test_block.body.to_plain_text).to eq("hello")
  end
end
