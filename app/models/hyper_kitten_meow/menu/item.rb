module HyperKittenMeow
  class Menu
    Item = Data.define(:id, :label, :path, :external, :page_id, :children) do
      def external? = external

      def children? = children.any?
    end
  end
end
