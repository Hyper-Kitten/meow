# frozen_string_literal: true

module HyperKittenMeow
  class Components::Icon < Components::Base
    SIZES = %i[xs sm md lg xl].freeze
    ICON_DIR = HyperKittenMeow::Engine.root.join("app/assets/images/hyper_kitten_meow/icons")

    def initialize(name, size: :md, **options)
      @name = name.to_s
      @size = size
      @options = options
    end

    def view_template
      path = ICON_DIR.join("#{@name}.svg")
      return unless path.file?

      classes = ["mw-icon", size_class, @options.delete(:class)].compact
      span(class: classes, style: inline_size, **@options) do
        raw(safe(path.read.sub(/\A<!--.*?-->\s*/m, "").strip))
      end
    end

    private

    def size_class
      "mw-icon--#{@size}" if SIZES.include?(@size)
    end

    def inline_size
      {width: "#{@size}px", height: "#{@size}px"} unless SIZES.include?(@size)
    end
  end
end
