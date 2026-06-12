# frozen_string_literal: true

module HyperKittenMeow
  class Components::Tag < Components::Base
    def initialize(label, active: false)
      @label = label
      @active = active
    end

    def view_template
      span(class: ["mw-tag", ("mw-tag--active" if @active)].compact) { @label }
    end
  end
end
