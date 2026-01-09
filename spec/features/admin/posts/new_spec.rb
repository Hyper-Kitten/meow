require "rails_helper"

RSpec.feature "Admin posts new", type: :feature do
  scenario "user can create posts", js: true do
    create_user_and_login(name: "Andrew")
    create(:user, name: "Josh")
    create(:tag, label: "coffee")

    visit hyper_kitten_meow.new_admin_post_path
    fill_in "Title", with: "Hello World!"
    fill_in "Summary", with: "My great summary!"
    fill_in_quill_editor "Body", with: "Fuzzy waffle!"
    fill_in "Slug", with: "my slug"
    select "Josh", from: "post[user_id]"
    check "coffee"
    check "Published"
    click_on "Create Post"

    expect(page).to have_text("Hello World!")
    expect(page).to have_text("My great summary!")
    expect(page).to have_text("my-slug")
    expect(page).to have_text("Josh")
    expect(page).to have_text("coffee")
    expect(page).to have_text("Post successfully created.")

    post = HyperKittenMeow::Post.last
    expect(post.body.to_plain_text).to eq("Fuzzy waffle!")
  end

  scenario "user can fix invalid posts" do
    create_user_and_login
    visit hyper_kitten_meow.new_admin_post_path

    fill_in "Title", with: ""
    click_on "Create Post"

    expect(page).to have_text("Title can't be blank")
  end
end
