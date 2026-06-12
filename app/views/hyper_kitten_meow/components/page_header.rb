# frozen_string_literal: true

module HyperKittenMeow
  class Components::PageHeader < Components::Base
    def initialize(title:, eyebrow: nil)
      @title = title
      @eyebrow = eyebrow
    end

    def view_template(&block)
      div(class: "mw-pageheader") do
        div do
          span(class: "ds-eyebrow mw-pageheader__eyebrow") { @eyebrow } if @eyebrow
          h1 { @title }
        end
        div(class: "mw-pageheader__actions", &block) if block_given?
      end
    end
  end
end
