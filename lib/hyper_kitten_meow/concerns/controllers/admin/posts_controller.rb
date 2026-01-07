module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module PostsController
          extend ActiveSupport::Concern

          def index
            @pagy, @posts = pagy(Post.sorted_by_published_date)
            render Views::Admin::Posts::Index.new(posts: @posts, pagy: @pagy)
          end

          def new
            @post = Post.new
            render Views::Admin::Posts::New.new(post: @post)
          end

          def create
            @post = Post.new(post_params)
            if @post.save
              flash[:success] = "Post successfully created."
              redirect_to admin_posts_path
            else
              flash[:error] = "There was a problem saving the post."
              render Views::Admin::Posts::New.new(post: @post), status: :unprocessable_entity
            end
          end

          def edit
            find_post
            render Views::Admin::Posts::Edit.new(post: @post)
          end

          def update
            find_post
            if @post.update(post_params)
              flash[:success] = "Post was successfully updated."
              redirect_to admin_posts_path
            else
              flash[:error] = "There was a problem saving the post."
              render Views::Admin::Posts::Edit.new(post: @post), status: :unprocessable_entity
            end
          end

          private

          def find_post
            @post = Post.find_by_slug!(params[:id])
          end

          def post_params
            params.require(:post).permit(:id, :title, :body, :summary, :slug, :published, :user_id, tag_ids: [])
          end
        end
      end
    end
  end
end
