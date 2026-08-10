# frozen_string_literal: true

module HyperKittenMeow
  class Components::Icon < Components::Base
    SIZES = %i[xs sm md lg xl].freeze
    NAME_PATTERN = /\A[a-z0-9-]+\z/
    ENGINE_ICON_DIR = HyperKittenMeow::Engine.root.join("app/assets/images/hyper_kitten_meow/icons")
    LUCIDE_ICON_DIR = HyperKittenMeow::Engine.root.join("lib/hyper_kitten_meow/icons")

    def self.icon_dirs
      [Rails.root.join("app/assets/images/icons"), ENGINE_ICON_DIR, LUCIDE_ICON_DIR]
    end

    def initialize(name, size: :md, **options)
      @name = name.to_s
      @size = size
      @options = options
    end

    def view_template
      markup = svg
      return log_missing_icon unless markup

      classes = ["mw-icon", size_class, @options.delete(:class)].compact
      span(class: classes, style: inline_size, **@options) do
        raw(safe(markup))
      end
    end

    private

    def svg
      return unless @name.match?(NAME_PATTERN)

      path = self.class.icon_dirs.lazy.map { |dir| dir.join("#{@name}.svg") }.find(&:file?)
      return unless path

      path.read.sub(/\A<!--.*?-->\s*/m, "").strip
    end

    def log_missing_icon
      return unless Rails.env.development? || Rails.env.test?

      Rails.logger.warn(
        "[hyper-kitten-meow] no icon named #{@name.inspect} in #{self.class.icon_dirs.join(", ")}"
      )
      nil
    end

    def size_class
      "mw-icon--#{@size}" if SIZES.include?(@size)
    end

    def inline_size
      {width: "#{@size}px", height: "#{@size}px"} unless SIZES.include?(@size)
    end
  end
end
