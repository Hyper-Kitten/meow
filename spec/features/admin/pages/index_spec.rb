require "rails_helper"

RSpec.feature "Admin pages index", type: :feature do
  scenario "user can view pages" do
    create_user_and_login
    create(:page, title: "My Title")

    visit hyper_kitten_meow.admin_pages_path

    expect(page).to have_text("My Title")
  end

  it "paginates pages" do
    create_user_and_login
    paginates(factory: :page, increment: 10, selector: "tbody tr") do
      visit hyper_kitten_meow.admin_pages_path
    end
  end
end
