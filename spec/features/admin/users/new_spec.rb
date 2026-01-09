require "rails_helper"

RSpec.feature "Admin users new", type: :feature do
  scenario "user can create users" do
    create_user_and_login(name: "Andrew")

    visit hyper_kitten_meow.new_admin_user_path
    fill_in "Name", with: "David Byrne"
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Create User"

    expect(page).to have_text("David Byrne")
    expect(page).to have_text("test@test.com")
  end

  scenario "user can fix invalid users" do
    create_user_and_login
    visit hyper_kitten_meow.new_admin_user_path

    fill_in "Name", with: "Prince"
    fill_in "Email", with: "test@test.com"
    click_on "Create User"

    expect(page).to have_text("Password can't be blank")
  end
end
