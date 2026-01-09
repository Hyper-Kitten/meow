module HyperKittenMeow
  module Concerns
    module Controllers
      module PostsController
        extend ActiveSupport::Concern
        include Pagy::Backend

        included do
          helper Pagy::Frontend
        end

        def index
          posts = HyperKittenMeow::Post.published.order(published_at: :desc)
          pagy, posts = pagy(posts)
          render posts_index_view(posts, pagy)
        end

        def show
          post = HyperKittenMeow::Post.published.find_by_slug(params[:id])
          render post_show_view(post)
        end

        private

        def posts_index_view(posts, pagy)
          Views::Public::Posts::Index.new(posts: posts, pagy: pagy)
        end

        def post_show_view(post)
          Views::Public::Posts::Show.new(post: post)
        end
      end
    end
  end
end
