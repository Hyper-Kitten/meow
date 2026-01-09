# frozen_string_literal: true

module HyperKittenMeow
  class Views::Public::Base < Views::Base
    include Phlex::Rails::Helpers::ContentFor
    include Phlex::Rails::Helpers::Request

    def page_title
      t("title")
    end

    def body_class
      "d-flex flex-column h-100"
    end

    def head_content
      meta name: "description", content: (content_for(:page_description) || t("page_description"))
      meta name: "robots", content: "index,follow,noodp"
      meta name: "generator", content: "HyperKitten: Meow"
      meta name: "subject", content: t("site_subject")
      base href: request.base_url
    end

    def around_template(&block)
      super do
        render_header
        div(class: "container") { yield }
        render_footer
      end
    end

    private

    def render_header
      header(class: "bg-light py-3 mb-3") do
        nav(class: "navbar navbar-expand-lg navbar-light") do
          div(class: "container d-flex justify-content-between") do
            h1(class: "navbar-brand") do
              link_to t("title"), "/"
            end
          end
        end
      end
    end

    def render_footer
      footer(class: "footer mt-auto py-3 bg-light") do
        div(class: "container") do
          p { "By #{t('owner')}" }
        end
      end
    end
  end
end
