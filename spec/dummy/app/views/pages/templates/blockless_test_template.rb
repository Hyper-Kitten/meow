module Pages
  module Templates
    class BlocklessTestTemplate < HyperKittenMeow::BasePageTemplate
      def view_template
        h1 { "Built from models, no content blocks" }
      end
    end
  end
end
