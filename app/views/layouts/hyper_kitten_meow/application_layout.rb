module HyperKittenMeow
  class ApplicationLayout < ApplicationView
    include Phlex::Rails::Layout
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::AssetPath
    include Phlex::Rails::Helpers::T
    include Phlex::Rails::Helpers::ContentFor
    include Phlex::Rails::Helpers::Request


    def view_template(&block)
      doctype

      html(class: "h-100") do
        head do
          title { @page&.title || t('title') }
          meta "http-equiv": "x-ua-compatible", content: "ie=edge"
          meta name: "viewport", content: "width=device-width, initial-scale=1.0, maximum-scale=1.0"
          meta charset: "utf-8"
          meta name: "description", content: (content_for(:page_description) || t('page_description'))
          meta name: "robots", content: "index,follow,noodp"
          meta name: "generator", content: "HyperKitten: Meow"
          meta name: "subject", content: t('site_subject')
          base href: request.base_url
          stylesheet_link_tag "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css", integrity: "sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3", crossorigin: "anonymous"
          csrf_meta_tags
        end
        body class: "d-flex flex-column h-100" do
          header class: "bg-light py-3 mb-3" do
            nav class: "navbar navbar-expand-lg navbar-light" do
              div class: "container d-flex justify-content-between" do
                h1 class: "navbar-brand" do
                  link_to t('title'), '/'
                end
              end
            end
          end
          div class: "container" do
            yield
          end
          footer class: "footer mt-auto py-3 bg-light" do
            div class: "container" do
              p { "By #{t('owner')}" }
            end
          end
        end
      end
    end
  end
end
