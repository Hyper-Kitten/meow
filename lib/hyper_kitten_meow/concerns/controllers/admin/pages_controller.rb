module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module PagesController
          extend ActiveSupport::Concern

          def index
            @pagy, @pages = pagy(Page.all.order(title: :asc))
          end

          def new
            @page = Page.new
          end

          def create
            @page = Page.new(page_params)

            if @page.save
              flash[:success] = "Page successfully created."
              redirect_to admin_pages_path
            else
              flash[:error] = "There was a problem saving the page."
              render :new
            end
          end

          def edit
            find_page
          end

          def update
            find_page
            if @page.update(page_params)
              flash[:success] = "Page was successfully updated."
              redirect_to admin_pages_path
            else
              flash[:error] = "There was a problem saving the page."
              render action: 'edit'
            end
          end

          private

          def find_page
            @page = Page.find_by_slug!(params[:id])
          end

          def page_params
            params.require(:page).permit(:id, :title, :body, :slug, :published, :template)
          end
        end
      end
    end
  end
end
