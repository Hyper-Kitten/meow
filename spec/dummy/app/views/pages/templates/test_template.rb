class TestTemplate < HyperKittenMeow::BasePageTemplate
  register_content_blocks :test_block, :test_block_two

  def view_template
    h1 "Path: test_template.rb"
    p "Compare this snippet from page_template.rb:"
    h2 { "Test Block:" }
    p { @page.content_block(:test_block) }
    h2 { "Test Block Two:" }
    p { @page.content_block(:test_block_two) }
  end
end
