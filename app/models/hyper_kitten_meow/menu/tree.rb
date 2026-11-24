module HyperKittenMeow
  class Menu
    Tree = Data.define(:key, :items) do
      def trail_to(path)
        target = normalize(path)
        best = []
        walk = lambda do |items, ancestors|
          items.each do |item|
            trail = ancestors + [item]
            best = trail if trail.length > best.length && normalize(item.path) == target
            walk.call(item.children, trail)
          end
        end
        walk.call(items, [])
        best.freeze
      end

      def each_item(&block)
        return enum_for(:each_item) unless block

        walk = lambda do |items|
          items.each do |item|
            yield item
            walk.call(item.children)
          end
        end
        walk.call(items)
      end

      def empty? = items.empty?

      private

      def normalize(path)
        path.to_s.split(/[?#]/, 2).first.to_s.chomp("/").presence || "/"
      end
    end
  end
end
