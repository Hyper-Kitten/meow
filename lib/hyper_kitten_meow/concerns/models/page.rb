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
          validate :template_in_registered_templates

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
            HyperKittenMeow::BasePageTemplate.descendants
          end
        end

        def content_block(name)
          content_blocks.find_by(name: name)&.body
        end

        def template_klass
          template.constantize
        end

        def selected_template_content_blocks
          template_klass.content_blocks
        end

        def populated_template
          template_klass.new(page: self)
        end

        private

        def set_published_at_date
          if published_changed?(from: false, to: true)
            self.published_at = Time.current
          end
        end

        def template_in_registered_templates
          return if template.blank?

          unless self.class.templates.map(&:name).include?(template)
            errors.add(:template, "is not a registered template")
          end
        end
      end
    end
  end
end
