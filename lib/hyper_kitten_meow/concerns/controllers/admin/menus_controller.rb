module HyperKittenMeow
  module Concerns
    module Controllers
      module Admin
        module MenusController
          extend ActiveSupport::Concern

          ROW_FIELDS = %i[id parent_key position label link_type page_id url _destroy].freeze

          def index
            definitions = HyperKittenMeow.menus.values
            return redirect_to(edit_admin_menu_path(definitions.first.key)) if definitions.one?

            menus = Menu.where(key: definitions.map { |definition| definition.key.to_s }).index_by(&:key)
            counts = MenuItem.where(menu_id: menus.values.map(&:id)).group(:menu_id).count
            item_counts = definitions.to_h do |definition|
              [definition.key, counts.fetch(menus[definition.key.to_s]&.id, 0)]
            end

            render Views::Admin::Menus::Index.new(definitions: definitions, item_counts: item_counts)
          end

          def edit
            find_menu
            render edit_view
          end

          def update
            find_menu

            if @menu.replace_tree(tree_params)
              flash[:success] = "#{@definition.label} saved."
              redirect_to edit_admin_menu_path(@definition.key)
            else
              flash.now[:error] = "The menu wasn't saved. #{@menu.tree_errors.join(". ")}."
              render edit_view, status: :unprocessable_entity
            end
          end

          private

          def find_menu
            @definition = HyperKittenMeow.menus.values.find { |definition| definition.key.to_s == params[:key] }
            raise ActiveRecord::RecordNotFound, "No menu #{params[:key].inspect} is declared" unless @definition

            @menu = Menu.for_definition!(@definition)
          end

          def edit_view
            Views::Admin::Menus::Edit.new(
              menu: @menu,
              definition: @definition,
              pages: Page.order(:title).select(:id, :title, :published),
              menu_count: HyperKittenMeow.menus.size
            )
          end

          def tree_params
            params.require(:menu).permit(:submitted, items: ROW_FIELDS).fetch(:items, {})
          end
        end
      end
    end
  end
end
