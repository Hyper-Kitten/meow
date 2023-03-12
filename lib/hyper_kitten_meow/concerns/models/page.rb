module HyperKittenMeow
  module Concerns
    module Models
      module Page
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable

        included do
          has_many :page_content_blocks,
            class_name: "HyperKittenMeow::PageContentBlock",
            foreign_key: "page_id",
            dependent: :destroy
          has_many :content_blocks,
            through: :page_content_blocks,
            class_name: "HyperKittenMeow::ContentBlock",
            foreign_key: "content_block_id"

          validates_presence_of :title
          validates_length_of :title, maximum: 244
          validates_inclusion_of :template, in: templates, allow_blank: true

          before_save :set_published_at_date

          sluggify :slug, generated_from: :title

          accepts_nested_attributes_for :content_blocks,
            allow_destroy: true,
            reject_if: :all_blank
        end

        class_methods do
          def published
            where(published: true)
          end

          def templates
            templates_path = Rails.root.join("app/views/pages/templates/*")
            @templates = Dir.glob(templates_path).map do |path|
              File.basename(path).split(".").first
            end
          end
        end

        def content_block(name)
          content_blocks.find_by(name: name)&.body
        end

        private

        def set_published_at_date
          if published_changed?(from: false, to: true)
            self.published_at = Time.current
          end
        end
      end
    end
  end
end
