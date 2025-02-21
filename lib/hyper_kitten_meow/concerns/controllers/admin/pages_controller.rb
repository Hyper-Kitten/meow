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
            @page.content_blocks.build
            set_template_info
          end

          def create
            @page = Page.new(page_params)
            set_template_info

            if @page.save
              flash[:success] = "Page successfully created."
              redirect_to admin_pages_path
            else
              flash[:error] = @page.errors.full_messages.join(", ")
              render :new, status: :unprocessable_entity
            end
          end

          def edit
            find_page
            set_template_info
          end

          def update
            find_page
            set_template_info
            if @page.update(page_params)
              flash[:success] = "Page was successfully updated."
              redirect_to admin_pages_path
            else
              flash[:error] = "There was a problem saving the page."
              render action: "edit", status: :unprocessable_entity
            end
          end

          private

          def find_page
            @page = Page.find_by_slug!(params[:id])
          end

          def set_template_info
            @templates_and_content_blocks = HyperKittenMeow::BasePageTemplate.all_templates_and_blocks
          end

          def page_params
            params.require(:page).permit(
              :id,
              :title,
              :body,
              :slug,
              :published,
              {
                content_blocks_attributes: [
                  :id,
                  :name,
                  :body,
                  :_destroy
                ]
              },
              :template
            )
          end
        end
      end
    end
  end
end
