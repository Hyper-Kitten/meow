module HyperKitten
  module Meow
    module Admin
      module AdminHelper
        include Pagy::Frontend

        KEY_TRANSFORMATIONS = {
          "alert" => "warning",
          "error" => "danger",
          "notice" => "info"
        }

        def user_facing_flashes
          flashes = flash.to_hash.slice("alert", "error", "notice", "success")
          flashes.transform_keys do |key|
            KEY_TRANSFORMATIONS[key]
          end
        end
      end
    end
  end
end
