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
          @page = HyperKittenMeow::Page.find_by_slug(params[:id])
        end
      end
    end
  end
end
