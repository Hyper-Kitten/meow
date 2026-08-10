# frozen_string_literal: true

module HyperKittenMeow
  class Components::Wordmark < Components::Base
    include Phlex::Rails::Helpers::AssetPath
    include Phlex::Rails::Helpers::T

    MARK = "hyper_kitten_meow/meow-mark.svg"
    LIGHT_MARK = "hyper_kitten_meow/meow-mark-light.svg"

    def initialize(light: false, mark_only: false, text: nil, mark: nil)
      @light = light
      @mark_only = mark_only
      @text = text
      @mark = mark
    end

    def view_template
      span(class: ["mw-wordmark", ("mw-wordmark--light" if @light)]) do
        img(src: asset_path(mark), alt: text) if mark
        unless @mark_only
          span(class: "mw-wordmark__text") do
            plain text
            span(class: "dot") { "." }
          end
        end
      end
    end

    private

    def text
      @text || t("title")
    end

    def mark
      return @mark unless @mark.nil?

      @light ? LIGHT_MARK : MARK
    end
  end
end
