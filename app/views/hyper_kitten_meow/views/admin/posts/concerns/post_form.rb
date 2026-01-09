# frozen_string_literal: true

module HyperKittenMeow
  module Views::Admin::Posts::Concerns::PostForm
    def render_post_form(post, url:, method:, cancel_path:)
      render Components::Form.new(model: post, url: url, method: method) do |f|
        f.text_field :title, required: true
        f.text_area :summary, rows: 2
        f.rich_text_area :body, label: "Body"
        f.collection_select :user_id, User.all, text_method: :name, label: "Author", required: true
        f.text_field :slug
        f.collection_check_boxes :tag_ids, Categorical::Tag.all, text_method: :label, label: "Tags"

        hr

        f.check_box :published

        div(class: "d-flex justify-content-between mt-4") do
          render Components::LinkButton.new(cancel_path, "Cancel", scheme: :secondary)
          f.submit
        end
      end
    end
  end
end
