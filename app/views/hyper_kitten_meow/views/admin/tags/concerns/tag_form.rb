# frozen_string_literal: true

module HyperKittenMeow
  module Views::Admin::Tags::Concerns::TagForm
    def render_tag_form(tag, url:, method:, cancel_path:)
      render Components::Form.new(model: tag, url: url, method: method) do |f|
        f.text_field :label, required: true

        div(class: "mw-form-actions") do
          render Components::LinkButton.new(cancel_path, "Cancel", scheme: :ghost)
          f.submit
        end
      end
    end
  end
end
