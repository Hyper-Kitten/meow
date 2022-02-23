module HyperKitten
  module Meow
    module Admin
      module AdminHelper
        include Pagy::Frontend

        def user_facing_flashes
          flash.to_hash.slice("alert", "error", "notice", "success")
        end
      end
    end
  end
end
