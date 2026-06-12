# frozen_string_literal: true

module HyperKittenMeow
  class Components::LinkButton < Components::Base
    include Phlex::Rails::Helpers::LinkTo

    SCHEMES = {
      primary: "btn btn-primary",
      secondary: "btn btn-secondary",
      outline_primary: "btn btn-outline-primary",
      outline_secondary: "btn btn-outline-secondary",
      outline_info: "btn btn-outline-info",
      outline_danger: "btn btn-outline-danger",
      ghost: "btn btn-ghost",
      sm_outline_info: "btn btn-sm btn-outline-info",
      sm_outline_danger: "btn btn-sm btn-outline-danger",
      sm_ghost: "btn btn-sm btn-ghost"
    }.freeze

    def initialize(path, text, scheme: :primary, icon: nil, **options)
      @path = path
      @text = text
      @scheme = scheme
      @icon = icon
      @options = options
    end

    def view_template
      css_class = SCHEMES.fetch(@scheme, SCHEMES[:primary])
      css_class = "#{css_class} #{@options.delete(:class)}" if @options[:class]

      link_to @path, class: css_class, **@options do
        render Components::Icon.new(@icon, size: icon_size) if @icon
        plain @text
      end
    end

    private

    def icon_size
      @scheme.to_s.start_with?("sm_") ? :sm : :lg
    end
  end
end
