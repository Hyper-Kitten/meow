# frozen_string_literal: true

module HyperKittenMeow
  class Components::Wordmark < Components::Base
    include Phlex::Rails::Helpers::AssetPath

    def initialize(light: false, mark_only: false)
      @light = light
      @mark_only = mark_only
    end

    def view_template
      mark = @light ? "hyper_kitten_meow/meow-mark-light.svg" : "hyper_kitten_meow/meow-mark.svg"
      span(class: ["mw-wordmark", ("mw-wordmark--light" if @light)]) do
        img(src: asset_path(mark), alt: "Meow")
        unless @mark_only
          span(class: "mw-wordmark__text") do
            plain "Meow"
            span(class: "dot") { "." }
          end
        end
      end
    end
  end
end
