# frozen_string_literal: true

module HyperKittenMeow
  class Components::PageHeader < Components::Base
    def initialize(title:)
      @title = title
    end

    def view_template(&block)
      div(class: "d-flex justify-content-between align-items-center mb-4") do
        h2 { @title }
        div(class: "action", &block) if block_given?
      end
    end
  end
end
