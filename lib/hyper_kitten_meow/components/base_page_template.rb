module HyperKittenMeow
  class BasePageTemplate < Phlex::HTML
    TEMPLATES_PATH = "app/views/pages/templates"

    class << self
      attr_reader :content_blocks

      def title
        id.titleize
      end

      def register_content_blocks(*blocks)
        @content_blocks = blocks.map(&:to_sym)
      end

      def all_templates
        Dir[Rails.root.join(TEMPLATES_PATH, "*.rb")].map do |file|
          File.basename(file, ".rb").camelize.constantize
        rescue NameError
          nil
        end.compact
      end

      def to_label
        title
      end

      def id
        name
      end

      def all_templates_and_blocks
        all_templates.each_with_object({}) do |template, templates|
          block_info = template.content_blocks.map do |block|
            {title: block.to_s.titleize, value: block.to_s}
          end
          templates[template.id] = {"blocksInfo" => block_info}
        end
      end
    end

    def initialize(page:)
      @page = page
    end
  end
end
