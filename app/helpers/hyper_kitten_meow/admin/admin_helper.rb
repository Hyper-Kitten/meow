module HyperKittenMeow
  module Admin
    module AdminHelper
      include Pagy::Frontend

      def table(...)
        render HyperKittenMeow::Table.new(...)
      end
    end
  end
end
