require "rails_helper"

RSpec.feature "Admin users index", type: :feature do
  scenario "user can view users" do
    create_user_and_login
    create(:user, name: "Elvis Costello")

    visit hyper_kitten_meow.admin_users_path

    expect(page).to have_text("Elvis Costello")
  end

  scenario "user can paginate through the users" do
    create_user_and_login
    # The user created for logging in also is included here
    FactoryBot.create_list(:user, 10)

    visit hyper_kitten_meow.admin_users_path
    expect(page).to have_selector(".user", count: 10)
    click_on(">")

    expect(page).to have_selector(".user", count: 1)
  end
end
