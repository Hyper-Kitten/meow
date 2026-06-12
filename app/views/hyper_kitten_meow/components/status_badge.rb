# frozen_string_literal: true

module HyperKittenMeow
  class Components::StatusBadge < Components::Base
    def initialize(published:)
      @published = published
    end

    def view_template
      if @published
        span(class: "mw-badge mw-badge--published") { "● Published" }
      else
        span(class: "mw-badge") { "○ Draft" }
      end
    end
  end
end
