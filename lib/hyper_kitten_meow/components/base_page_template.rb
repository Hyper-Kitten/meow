module HyperKittenMeow
  class BasePageTemplate < Phlex::HTML
    class << self
      attr_reader :content_blocks

      def title
        name.demodulize.titleize
      end

      def register_content_blocks(*blocks)
        @content_blocks = blocks.map(&:to_sym)
      end
      # def register_content_blocks(*blocks)
      #   @content_blocks = blocks.map(&:to_sym)
      #
      #   blocks.each do |block|
      #     attr_accessor block
      #   end
      #   # blocks.each do |block|
      #   #   define_method(block) do
      #   #     instance_variable_get("@#{block}")
      #   #   end
      #   # end
      #   #
      #   # define_method(:initialize) do |**args|
      #   #   blocks.each do |block|
      #   #     instance_variable_set("@#{block}", args[block])
      #   #   end
      #   # end
      # end
      #
      # def content_blocks
      #   attri
      #
      #   # instance_method(:initialize).parameters.select do |(type, name)|
      #   #   type == :keyreq || type == :key
      #   # end.map(&:last).map(&:to_s).map(&:titleize)
      # end
    end

    def initialize(page)
      @page = page
    end
  end
end
