# frozen_string_literal: true

module HyperKittenMeow
  class Components::Pagination < Components::Base
    include Pagy::Method

    def initialize(pagy:)
      @pagy = pagy
    end

    def view_template
      return if @pagy.pages <= 1

      raw safe(@pagy.series_nav(:bootstrap))
    end
  end
end
