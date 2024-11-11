module HyperKittenMeow
  module Concerns
    module Controllers
      module PagesController
        extend ActiveSupport::Concern

        def show
          slug = params[:id]
          @page = HyperKittenMeow::Page.published.find_by_slug!(slug)
          template_name = if @page.template.present?
            render @page.populated_template
          else
            "show"
          end

          render template: template_name
        end
      end
    end
  end
end
