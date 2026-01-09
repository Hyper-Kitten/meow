module HyperKittenMeow
  module Concerns
    module Controllers
      module PagesController
        extend ActiveSupport::Concern

        def show
          slug = params[:id]
          page = HyperKittenMeow::Page.published.find_by_slug!(slug)
          if page.template.present?
            render page.populated_template
          else
            render Views::Public::Pages::Show.new(page: page)
          end
        end
      end
    end
  end
end
