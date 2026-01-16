require "rails_helper"

RSpec.feature "Admin pages new", type: :feature do
  scenario "user can create pages", js: true do
    create_user_and_login

    visit hyper_kitten_meow.new_admin_page_path
    expect(page).to have_content("New Page")

    fill_in "Title", with: "Hello World!"
    select "Test Template", from: "Template"
    within(".content-blocks") do
      fill_in_quill_editor "Test Block", with: "Fuzzywaffle!"
    end
    check "Published"
    click_on "Create Page"

    expect(page).to have_text("Page successfully created.")
    expect(current_path).to eq(hyper_kitten_meow.admin_pages_path)
    expect(page).to have_text("Hello World!")
    meow_page = HyperKittenMeow::Page.last
    expect(meow_page.content_blocks.first.name).to eq("test_block")
    expect(meow_page.content_blocks.first.body.to_plain_text).to eq("Fuzzywaffle!")
  end

  scenario "user can fix invalid pages", js: true do
    create_user_and_login

    visit hyper_kitten_meow.new_admin_page_path
    expect(page).to have_content("New Page")

    fill_in "Title", with: ""
    click_on "Create Page"

    expect(page).to have_text("Title can't be blank")
  end
end
