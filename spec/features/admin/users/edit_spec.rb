require "rails_helper"

RSpec.feature "Admin users edit", type: :feature do
  scenario "user can edit users" do
    create_user_and_login(name: "Andrew")
    user = create(:user, name: "Josh")

    visit hyper_kitten_meow.edit_admin_user_path(user)

    expect(page).to have_text("Josh")

    fill_in "Name", with: "Elvis"
    fill_in "Email", with: "test@test.com"
    click_on "Update User"

    expect(page).to have_text("Elvis")
    expect(page).to have_text("test@test.com")
  end
end
