require "rails_helper"

RSpec.feature "Admin posts edit", type: :feature do
  scenario "existing rich text content appears in editor", js: true do
    create_user_and_login
    post = create(:post, body: "Existing body content")

    visit hyper_kitten_meow.edit_admin_post_path(post)

    expect(page).to have_css(".ql-editor", text: "Existing body content")
  end

  scenario "user can edit posts", js: true do
    create_user_and_login(name: "Andrew")
    create(:user, name: "Josh")
    post = create(:post, title: "My Title")
    create(:tag, label: "coffee")

    visit hyper_kitten_meow.edit_admin_post_path(post)

    expect(page).to have_text("My Title")

    fill_in "Title", with: "Hello World!"
    fill_in "Summary", with: "My great summary!"
    fill_in_quill_editor "Body", with: "Fuzzy waffle!"
    fill_in "Slug", with: "my slug"
    check "coffee"
    select "Josh", from: "post[user_id]"
    check "Published"
    click_on "Update Post"

    expect(page).to have_text("Hello World!")
    expect(page).to have_text("My great summary!")
    expect(page).to have_text("my-slug")
    expect(page).to have_text("Josh")
    expect(page).to have_text("Josh")
    expect(page).to have_text("coffee")

    post = HyperKittenMeow::Post.last
    expect(post.body.to_plain_text).to eq("Fuzzy waffle!")
  end
end
