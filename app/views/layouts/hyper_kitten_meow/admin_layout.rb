module HyperKittenMeow
  class AdminLayout < ApplicationView
    include Phlex::Rails::Layout
    include Phlex::Rails::Helpers::Flash
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::T
    include Phlex::Rails::Helpers::Routes


    def view_template(&block)
      doctype

      html(class: "h-100") do
        head do
          meta content: "text/html; charset=UTF-8", "http-equiv": "Content-Type"
          title { t("title") }
          stylesheet_link_tag "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css", integrity: "sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3", crossorigin: "anonymous"
          stylesheet_link_tag "https://cdn.quilljs.com/1.3.6/quill.snow.css"
          stylesheet_link_tag "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css"
          javascript_importmap_tags
          javascript_import_module_tag "hyper_kitten_meow/application"
          csrf_meta_tags
        end
        body_content(&block)
      end
    end

    private

    def body_content(&block)
      body(class: "h-100") do
        div(class: "container-fluid h-100") do
          div(class: "row h-100") do
            nav_content
            div(class: "col-md-9 col-lg-10 mt-3 px-4") do
              flash_content
              yield
            end
          end
        end
      end
    end

    def flash_content
      if flash.any?
        helpers.user_facing_flashes.each do |key, value|
          div(class: "alert alert-#{key}") { value }
        end
      end
    end

    def nav_content
      nav(class: "col-md-3 col-lg-2 d-md-block sidebar bg-dark text-white d-flex flex-column") do
        h3(class: "mb-3 mt-3") { t("title") }
        hr
        if helpers.logged_in?
          ul(class: "nav nav-pills flex-column mb-auto") do
            li(class: "nav-item") { link_to "Posts", helpers.hyper_kitten_meow.admin_posts_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Pages", helpers.hyper_kitten_meow.admin_pages_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Tags", helpers.hyper_kitten_meow.admin_tags_path, class: "nav-link text-white" }
            li(class: "nav-item") { link_to "Users", helpers.hyper_kitten_meow.admin_users_path, class: "nav-link text-white" }
          end
          hr
          link_to "#", class: "nav-link d-flex align-items-center text-white text-decoration-none dropdown-toggle", data: { "bs-toggle": "dropdown" }, "aria-expanded": false do
            strong { helpers.current_user.name }
          end
          ul(class: "dropdown-menu dropdown-menu-dark text-small shadow") do
            li { link_to t('sessions.destroy'), helpers.hyper_kitten_meow.admin_logout_path, class: "dropdown-item" }
          end
        end
      end
    end
  end
end
