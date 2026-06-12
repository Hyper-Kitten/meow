# frozen_string_literal: true

module HyperKittenMeow
  class Components::ButtonGroup < Components::Base
    def initialize(attached: false, align: nil, **options)
      @attached = attached
      @align = align
      @options = options
    end

    def view_template(&block)
      classes = [
        "mw-btn-group",
        ("mw-btn-group--attached" if @attached),
        ("mw-btn-group--end" if @align == :end),
        @options.delete(:class)
      ].compact
      div(class: classes, **@options, &block)
    end
  end
end
