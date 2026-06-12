# frozen_string_literal: true

module HyperKittenMeow
  class Components::Button < Components::Base
    include Phlex::Rails::Helpers::ButtonTo

    VARIANTS = {
      primary: "btn-primary",
      secondary: "btn-secondary",
      outline: "btn-outline",
      ghost: "btn-ghost",
      danger: "btn-danger"
    }.freeze

    def initialize(text = nil, to:, variant: :primary, size: :md, icon: nil, **options)
      @text = text
      @to = to
      @variant = variant
      @size = size
      @icon = icon
      @options = options
    end

    def view_template(&block)
      attrs = mix({class: ["btn", VARIANTS.fetch(@variant, "btn-primary"), ("btn-sm" if @size == :sm)], form_class: "d-inline"}, @options)

      button_to @to, **attrs do
        render Components::Icon.new(@icon, size: (@size == :sm ? :sm : :lg)) if @icon
        @text ? plain(@text) : yield
      end
    end
  end
end
