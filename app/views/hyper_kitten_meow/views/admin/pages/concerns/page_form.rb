# frozen_string_literal: true

module HyperKittenMeow
  module Views::Admin::Pages::Concerns::PageForm
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::FieldsFor
    include Phlex::Rails::Helpers::DOMID

    def render_page_form(page, templates_and_content_blocks:, url:, method:, cancel_path:)
      div(data: {content_blocks_blocks_value: templates_and_content_blocks.to_json, controller: "content-blocks"}) do
        render Components::Form.new(model: page, url: url, method: method) do |f|
          f.text_field :title, required: true

          f.select(
            :template,
            Page.templates.map { |t| [t.title, t.to_s] },
            label: "Template",
            include_blank: false,
            data: {action: "change->content-blocks#updateContentBlockFields", content_blocks_target: "templateField"}
          )

          render_content_blocks_card(f, page)

          f.text_field :slug

          hr

          f.check_box :published

          div(class: "d-flex justify-content-between mt-4") do
            render Components::LinkButton.new(cancel_path, "Cancel", scheme: :secondary)
            f.submit
          end
        end
      end
    end

    private

    def render_content_blocks_card(f, page)
      div(class: "card mb-3") do
        div(class: "card-body content-blocks") do
          h4 { "Content Blocks" }

          template(data: {content_blocks_target: "contentBlockFieldTemplate"}) do
            render_content_block_fields(f, ContentBlock.new, child_index: "NEW_RECORD")
          end

          div(class: "active-content-blocks", data: {content_blocks_target: "activeBlocksFields"}) do
            page.content_blocks.each_with_index do |content_block, index|
              render_content_block_fields(f, content_block, child_index: index)
            end
          end
        end
      end
    end

    def render_content_block_fields(f, content_block, child_index:)
      f.fields_for(:content_blocks, content_block, child_index: child_index) do |cb|
        div(class: "card content-block border my-3") do
          div(class: "card-body") do
            h4(class: "content-block-name") { content_block.name&.titleize }
            raw cb.hidden_field(:name, class: "content-block-name-field")

            div(class: "quill-fields-container", data: {block_name: content_block.name, content_blocks_target: "quillFieldsContainer"}) do
              raw cb.hidden_field(:body)
              div(class: "quill-container")
            end
          end
        end
      end
    end
  end
end
