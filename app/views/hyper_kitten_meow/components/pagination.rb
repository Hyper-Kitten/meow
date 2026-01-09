# frozen_string_literal: true

module HyperKittenMeow
  class Components::Pagination < Components::Base
    include Phlex::Rails::Helpers::Request
    include Pagy::Frontend

    def initialize(pagy:)
      @pagy = pagy
    end

    def view_template
      return if @pagy.pages <= 1

      raw safe(pagy_bootstrap_nav(@pagy))
    end
  end
end
