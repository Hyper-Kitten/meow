module HyperKittenMeow
  class Menu
    # Applies a whole menu tree posted by the admin editor in one transaction. Rows arrive
    # keyed by the editor's row key (an item id, or a negative number for a new row), with
    # parent_key pointing at another row's key.
    class TreeUpdate
      Row = Struct.new(:key, :parent_key, :item, :errors, :children, :depth) do
        def too_deep?(max_depth) = depth.to_i > max_depth
      end

      def self.rows_for_items(items)
        rows = items.map do |item|
          Row.new(key: item.id.to_s, parent_key: item.parent_id&.to_s, item: item, errors: [], children: [])
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
        roots
      end

      attr_reader :menu, :rows

      def initialize(menu, posted_rows)
        @menu = menu
        @posted = normalize(posted_rows)
        @existing = menu.items.includes(:page).index_by { |item| item.id.to_s }
        @flat = build_rows
        @rows = self.class.link(@flat)
      end

      def save
        check_structure
        @flat.each { |row| row.errors.concat(row.item.errors.full_messages) unless row.item.valid? }
        return false if @flat.any? { |row| row.errors.any? }

        menu.transaction do
          menu.class.no_touching do
            @flat.sort_by(&:depth).each { |row| row.item.save! }
            MenuItem.where(menu_id: menu.id).where.not(id: @flat.map { |row| row.item.id }).delete_all
          end
          menu.touch
        end
        menu.items.reset
        true
      end

      def error_messages
        @flat.flat_map do |row|
          name = row.item.display_label.presence || "New item"
          row.errors.map { |message| "#{name}: #{message}" }
        end
      end

      private

      def normalize(posted_rows)
        posted_rows = posted_rows.to_h if posted_rows.respond_to?(:permitted?)
        posted_rows.to_h.map { |key, attrs| [key.to_s, attrs.to_h.symbolize_keys] }
      end

      def build_rows
        kept = @posted.reject { |_key, attrs| ActiveModel::Type::Boolean.new.cast(attrs[:_destroy]) }
        ordered = kept.each_with_index.sort_by { |(_key, attrs), index| [attrs[:position].to_i, index] }.map(&:first)

        ordered.map do |key, attrs|
          item = @existing[attrs[:id].to_s] || menu.items.build
          assign(item, attrs)
          Row.new(key: key, parent_key: attrs[:parent_key].presence&.to_s, item: item, errors: [], children: [])
        end
      end

      def assign(item, attrs)
        item.label = attrs[:label] if attrs.key?(:label)
        case attrs[:link_type]
        when "url"
          item.page_id = nil
          item.url = attrs[:url]
        when "page"
          item.page_id = attrs[:page_id].presence
          item.url = nil
        else
          item.page_id = attrs[:page_id].presence if attrs.key?(:page_id)
          item.url = attrs[:url] if attrs.key?(:url)
        end
      end

      def check_structure
        by_key = @flat.index_by(&:key)
        max_depth = menu.definition&.depth || 1

        @flat.each do |row|
          parent = row.parent_key && by_key[row.parent_key]
          if row.parent_key && parent.nil?
            row.errors << "The item it was under was removed"
            next
          end
          row.item.parent = parent&.item

          depth = 1
          seen = [row]
          node = parent
          while node
            if seen.include?(node)
              row.errors << "Can't be under itself"
              break
            end
            seen << node
            depth += 1
            node = node.parent_key && by_key[node.parent_key]
          end
          row.errors << "Too deep for this menu" if depth > max_depth
        end

        @flat.group_by(&:parent_key).each_value do |siblings|
          siblings.each_with_index { |row, index| row.item.position = index }
        end
      end
    end
  end
end
