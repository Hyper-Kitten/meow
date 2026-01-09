require "rails_helper"

RSpec.feature "Admin posts index", type: :feature do
  scenario "user can view posts" do
    create_user_and_login
    create(:post, title: "My Title")

    visit hyper_kitten_meow.admin_posts_path

    expect(page).to have_text("My Title")
  end

  it "paginates posts" do
    create_user_and_login
    paginates(factory: :post, increment: 10, selector: "tbody tr") do
      visit hyper_kitten_meow.admin_posts_path
    end
  end
end
