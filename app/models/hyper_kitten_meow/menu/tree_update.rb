module HyperKittenMeow
  class Menu
    # Applies a whole menu tree posted by the admin editor in one transaction. Rows arrive
    # keyed by the editor's row key (an item id, or a negative number for a new row), with
    # parent_key pointing at another row's key.
    class TreeUpdate
      Row = Struct.new(:key, :parent_key, :item, :errors, :children, :depth) do
        def initialize(errors: [], children: [], **) = super

        def too_deep?(max_depth) = depth.to_i > max_depth
      end

      def self.rows_for_items(items)
        rows = items.map do |item|
          Row.new(key: item.id.to_s, parent_key: item.parent_id&.to_s, item: item)
        end
        link(rows)
      end

      def self.link(rows)
        by_key = rows.index_by(&:key)
        roots = []
        rows.each do |row|
          parent = row.parent_key && by_key[row.parent_key]
          parent ? parent.children << row : roots << row
        end
        assign_depth = lambda do |level, depth|
          level.each do |row|
            row.depth = depth
            assign_depth.call(row.children, depth + 1)
          end
        end
        assign_depth.call(roots, 1)

        # Rows whose parent chain loops never hang off a root. Show them at the top level so the
        # editor can still see and post them; otherwise the next save would delete them.
        unplaced = rows.select { |row| row.depth.nil? }
        unplaced.each { |row| row.children.select! { |child| child.depth } }
        roots + unplaced
      end

      attr_reader :menu, :rows

      def initialize(menu, posted_rows, version: nil)
        @menu = menu
        @version = version
        @posted = normalize(posted_rows)
        @existing = menu.items.includes(:page).index_by { |item| item.id.to_s }
        @pages = Page.where(id: @posted.filter_map { |_key, attrs| attrs[:page_id].presence }).index_by { |page| page.id.to_s }
        @flat = build_rows
        @rows = self.class.link(@flat)
      end

      def save
        if stale?
          @stale = true
          return false
        end

        check_structure
        @flat.each { |row| row.errors.concat(row.item.errors.full_messages) unless row.item.valid? }
        return false if @flat.any? { |row| row.errors.any? }

        menu.transaction do
          menu.class.no_touching do
            @flat.sort_by(&:depth).each { |row| row.item.save!(validate: false) }
            MenuItem.where(menu_id: menu.id).where.not(id: @flat.map { |row| row.item.id }).delete_all
          end
          menu.touch
        end
        menu.items.reset
        true
      end

      def error_messages
        if @stale
          return ["Someone else saved this menu after you opened it. Save again to replace their changes " \
                  "with yours, or Discard to see theirs"]
        end

        @flat.flat_map do |row|
          name = row.item.display_label.presence || "New item"
          row.errors.map { |message| "#{name}: #{message}" }
        end
      end

      private

      def normalize(posted_rows)
        posted_rows.to_h.map { |key, attrs| [key.to_s, attrs.to_h.symbolize_keys] }
      end

      def build_rows
        kept = @posted.reject { |_key, attrs| ActiveModel::Type::Boolean.new.cast(attrs[:_destroy]) }
        ordered = kept.each_with_index.sort_by { |(_key, attrs), index| [attrs[:position].to_i, index] }.map(&:first)

        ordered.map do |key, attrs|
          item = @existing[attrs[:id].to_s] || menu.items.build
          assign(item, attrs)
          Row.new(key: key, parent_key: attrs[:parent_key].presence&.to_s, item: item)
        end
      end

      def assign(item, attrs)
        item.label = attrs[:label]
        if attrs[:link_type] == "url"
          item.page = nil
          item.url = attrs[:url]
        else
          page_id = attrs[:page_id].presence
          if (page = @pages[page_id.to_s])
            item.page = page
          else
            item.page_id = page_id
          end
          item.url = nil
        end
      end

      def stale?
        @version.present? && @version != menu.edit_version
      end

      def check_structure
        by_key = @flat.index_by(&:key)
        max_depth = menu.definition&.depth || 1

        @flat.each do |row|
          if row.parent_key && !by_key.key?(row.parent_key)
            row.errors << "The item it was under was removed"
          elsif row.depth.nil?
            row.errors << "Its place in the menu loops back on itself"
          else
            row.item.parent = by_key[row.parent_key]&.item
            row.errors << "Too deep for this menu" if row.too_deep?(max_depth)
          end
        end

        @flat.group_by(&:parent_key).each_value do |siblings|
          siblings.each_with_index { |row, index| row.item.position = index }
        end
      end
    end
  end
end
