require "rails_helper"

RSpec.feature "Viewing a post", :type => :feature do
  scenario "a visitor can view published posts" do
    post = create(
      :post,
      published: true,
      title: "My Title",
      body: "Some content",
    )

    visit hyper_kitten_meow.posts_path
    click_link("My Title")

    expect(current_path).to eq(hyper_kitten_meow.post_path(post))
    expect(page).to have_text("My Title")
    expect(page).to have_text("Some content")
  end

  scenario "a visitor cannot view unpublished posts" do
    post = create(:post, published: false)

    expect { visit hyper_kitten_meow.post_path(post) }.
      to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario "a visitor will see the post's title as the page's title" do
    post = create(:post, published: true, title: 'my title!', summary: 'summary')

    visit hyper_kitten_meow.post_path(post)

    expect(page).to have_title('my title!')
    expect(page).to have_css("meta[name='description'][content='summary']",
                             visible: false)
  end
end
