# frozen_string_literal: true

module HyperKittenMeow
  class Components::Flash < Components::Base
    KINDS = {
      "alert" => "warning",
      "error" => "danger",
      "notice" => "info",
      "success" => "success"
    }.freeze

    def initialize(flash:)
      @flash = flash
    end

    def view_template
      messages.each do |key, value|
        kind = KINDS[key]
        div(class: "mw-flash mw-flash--#{kind}") do
          render Components::Icon.new(icon_for(kind), size: :sm)
          span { value }
        end
      end
    end

    private

    def messages
      @flash.to_hash.slice(*KINDS.keys)
    end

    def icon_for(kind)
      (kind == "danger" || kind == "warning") ? "alert-triangle" : "check-circle-2"
    end
  end
end
