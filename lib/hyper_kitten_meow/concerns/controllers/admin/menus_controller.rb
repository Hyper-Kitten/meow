module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module MenusController
          extend ActiveSupport::Concern
          def index
            @pagy, @menus = pagy(Menu.all)
          end

          def new
            @menu = Menu.new
            @menu.menu_items.build(position: 1)
          end

          def create
            @menu = Menu.new(menu_params)
            if @menu.save
              flash[:success] = "Menu was successfully created."
              redirect_to admin_menus_path
            else
              flash[:error] = "There was a problem saving the menu."
              render :new
            end
          end

          def edit
            find_menu
            @menu.menu_items.build(position: 1) unless @menu.menu_items.exists?
          end

          def update
            find_menu
            if @menu.update(menu_params)
              flash[:success] = "Menu was successfully updated."
              redirect_to admin_menus_path
            else
              flash[:error] = "There was a problem saving the menu."
              render action: 'edit'
            end
          end

          def destroy
            find_menu
            @menu.destroy
            flash[:success] = "Menu was successfully deleted."
            redirect_to admin_menus_path
          end

          private

          def find_menu
            @menu = Menu.find_by_slug!(params[:id])
          end

          def menu_params
            params.require(:menu).permit(:id, :name, menu_items_attributes: [:id, :title, :page_id, :position, :new_window, :url, :_destroy])
          end
        end
      end
    end
  end
end
