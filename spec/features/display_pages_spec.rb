require "rails_helper"

RSpec.feature "Displaying pages", :type => :feature do
  scenario "visitor can view hardcoded pages" do
    visit hyper_kitten_meow.page_path("hardcoded-page")

    expect(page).to have_text("This is a hardcoded page")
  end

  scenario "visitor can view pages created in the database" do
    cms_page = create(
      :page,
      slug: "test-page",
      title: "This is a test page",
      published: true
    )

    visit hyper_kitten_meow.page_path("test-page")

    expect(page).to have_text("This is a test page")
  end
end
