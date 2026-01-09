# frozen_string_literal: true

module HyperKittenMeow
  class Views::Base < Components::Base
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::ButtonTo
    include Phlex::Rails::Helpers::CSRFMetaTags
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavascriptImportmapTags
    include Phlex::Rails::Helpers::JavascriptImportModuleTag
    include Phlex::Rails::Helpers::T

    def around_template(&block)
      doctype
      html(class: "h-100") do
        render_head
        body(class: body_class) { super(&block) }
      end
    end

    def page_title
      t("title")
    end

    def head_content
    end

    def body_class
      "h-100"
    end

    private

    def render_head
      head do
        meta content: "text/html; charset=UTF-8"
        title { page_title }
        meta name: "viewport", content: "width=device-width,initial-scale=1"

        csrf_meta_tags

        head_content

        stylesheet_link_tag "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css",
          integrity: "sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3",
          crossorigin: "anonymous"
      end
    end
  end
end
