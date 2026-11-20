require "rails_helper"

RSpec.feature "Signed-out admin visits", type: :feature do
  scenario "an admin page sends the visitor to log in, then back to that page" do
    user = create(:user)

    visit hyper_kitten_meow.admin_pages_path
    expect(page).to have_current_path(hyper_kitten_meow.admin_login_path)

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on I18n.t("sessions.submit")

    expect(page).to have_current_path(hyper_kitten_meow.admin_pages_path)
  end

  scenario "a host app's admin page sends the visitor to Meow's login, then back" do
    user = create(:user)

    visit "/admin/reports"
    expect(page).to have_current_path(hyper_kitten_meow.admin_login_path)

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on I18n.t("sessions.submit")

    expect(page).to have_current_path("/admin/reports")
    expect(page).to have_text("Reports")
  end

  scenario "logging in from the login page goes to the admin home" do
    login_as(create(:user))

    expect(page).to have_current_path(hyper_kitten_meow.admin_root_path)
  end
end
