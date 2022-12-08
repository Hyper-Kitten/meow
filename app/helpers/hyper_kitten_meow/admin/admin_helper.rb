module HyperKittenMeow
  module Admin
    module AdminHelper
      include Pagy::Frontend

      KEY_TRANSFORMATIONS = {
        "alert" => "warning",
        "error" => "danger",
        "notice" => "info",
        "success" => "success"
      }

      def user_facing_flashes
        flashes = flash.to_hash.slice("alert", "error", "notice", "success")
        flashes.transform_keys do |key|
          KEY_TRANSFORMATIONS[key]
        end
      end

      def table(...)
        render HyperKittenMeow::Table.new(...)
      end
    end
  end
end
