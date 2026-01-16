module Pages
  module Templates
    class AnotherTestTemplate < HyperKittenMeow::BasePageTemplate
      register_content_blocks :test_block_three, :test_block_four

      def view_template
        h1 { "Path: another_test_template.rb" }
        p { "Compare this snippet from page_template.rb:" }
        h2 { "Test Block Three:" }
        p { @page.content_block(:test_block_three).to_s }
        h2 { "Test Block Four:" }
        p { @page.content_block(:test_block_four).to_s }
      end
    end
  end
end
