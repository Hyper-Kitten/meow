module HyperKitten
  module Meow
    module Concerns
      module Controllers
        module PostsController
          extend ActiveSupport::Concern

          def index
            @posts = Post.published.sorted_by_published_date.
              page(params[:page]).
              per(10)
          end

          def show
            @post = Post.published.find_by_slug!(params[:id])
          end
        end
      end
    end
  end
end
