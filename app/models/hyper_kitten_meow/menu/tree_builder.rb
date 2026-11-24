module HyperKittenMeow
  class Menu
    class TreeBuilder
      EXTERNAL_URL = %r{\Ahttps?://}i

      def initialize(menu, definition)
        @menu = menu
        @definition = definition
      end

      def call
        items = MenuItem.where(menu_id: @menu.id).eager_load(:page).order(:position, :id).to_a
        @by_parent = items.group_by(&:parent_id)
        Tree.new(key: @definition.key, items: build_level(nil, 1))
      end

      private

      def build_level(parent_id, depth)
        return [].freeze if depth > @definition.depth

        @by_parent.fetch(parent_id, []).filter_map { |item| build_item(item, depth) }.freeze
      end

      def build_item(item, depth)
        if item.page_id
          page = item.page
          return unless page&.published?

          label = item.label.presence || page.title
          path = HyperKittenMeow.page_path(page)
          external = false
        elsif item.url.present?
          label = item.label
          path = item.url
          external = item.url.match?(EXTERNAL_URL)
        else
          return
        end

        Item.new(
          id: item.id,
          label: label,
          path: path,
          external: external,
          page_id: item.page_id,
          children: build_level(item.id, depth + 1)
        )
      end
    end
  end
end
