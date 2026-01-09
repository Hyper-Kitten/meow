# frozen_string_literal: true

module HyperKittenMeow
  class Views::Public::Pages::Show < Views::Public::Base
    def initialize(page:)
      @page = page
    end

    def page_title
      @page.title
    end

    def view_template
      div(class: "container") do
        h2 { @page.title }
        raw safe(@page.body)
      end
    end
  end
end
