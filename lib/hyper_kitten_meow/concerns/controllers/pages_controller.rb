module HyperKittenMeow
  module Concerns
    module Controllers
      module PagesController
        extend ActiveSupport::Concern
        included do
          layout "hyper_kitten_meow/application"
          helper HyperKittenMeow::MenuHelper
        end

        def show
          slug = params[:id]
          template_name = slug.underscore
          if lookup_context.exists?(template_name, "hyper_kitten_meow/pages")
            template = lookup_context.find(template_name, "hyper_kitten_meow/pages")
            render template: template
          else
            @page = HyperKittenMeow::Page.find_by_slug(slug)
            unless @page
              raise ActionController::RoutingError.new("Not Found")
            end
          end
        end
      end
    end
  end
end
