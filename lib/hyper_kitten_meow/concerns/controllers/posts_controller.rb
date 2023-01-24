module HyperKittenMeow
  module Concerns
    module Controllers
      module PostsController
        extend ActiveSupport::Concern
        include Pagy::Backend

        included do
          layout "hyper_kitten_meow/application"
          helper Pagy::Frontend
        end

        def index
          posts = HyperKittenMeow::Post.published.order(published_at: :desc)
          @pagy, @posts = pagy(posts)
        end

        def show
          @post = HyperKittenMeow::Post.published.find_by_slug(params[:id])
        end
      end
    end
  end
end
