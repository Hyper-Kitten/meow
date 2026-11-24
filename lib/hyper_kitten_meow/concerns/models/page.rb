module HyperKittenMeow
  module Concerns
    module Models
      module Page
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable

        MENU_VISIBLE_ATTRIBUTES = %w[published slug title].freeze

        included do
          has_many :content_blocks,
            class_name: "HyperKittenMeow::ContentBlock",
            foreign_key: "page_id",
            inverse_of: :page,
            dependent: :destroy

          has_many :menu_items,
            class_name: "HyperKittenMeow::MenuItem",
            inverse_of: :page

          validates_presence_of :title
          validates_length_of :title, maximum: 244
          validate :template_in_registered_templates

          before_save :set_published_at_date
          after_save :remove_unregistered_content_blocks, if: :saved_change_to_template?

          sluggify :slug, generated_from: :title

          before_destroy :remember_linked_menus
          after_update_commit :touch_linked_menus, if: :menu_visible_change?
          after_destroy_commit :touch_remembered_menus

          accepts_nested_attributes_for :content_blocks,
            allow_destroy: true,
            reject_if: :all_blank
        end

        class_methods do
          def published
            where(published: true)
          end

          def templates
            HyperKittenMeow::BasePageTemplate.all_templates
          end
        end

        def content_block(name)
          content_blocks_by_name[name.to_s]&.body
        end

        def template_klass
          HyperKittenMeow::BasePageTemplate.find_template(template)
        end

        def selected_template_content_blocks
          template_klass&.content_blocks.to_a
        end

        def populated_template
          template_klass.new(page: self)
        end

        private

        def menu_visible_change?
          saved_changes.keys.intersect?(MENU_VISIBLE_ATTRIBUTES)
        end

        def touch_linked_menus
          touch_menus(menu_items.distinct.pluck(:menu_id))
        end

        def remember_linked_menus
          @linked_menu_ids = menu_items.distinct.pluck(:menu_id)
        end

        def touch_remembered_menus
          touch_menus(@linked_menu_ids)
        end

        def touch_menus(menu_ids)
          return if menu_ids.blank?

          HyperKittenMeow::Menu.where(id: menu_ids).touch_all
          HyperKittenMeow::Current.menu_trees = nil
        end

        def content_blocks_by_name
          @content_blocks_by_name ||=
            content_blocks.includes(:rich_text_body).index_by(&:name)
        end

        def set_published_at_date
          if published_changed?(from: false, to: true)
            self.published_at = Time.current
          end
        end

        def remove_unregistered_content_blocks
          return if template.blank?

          registered_names = selected_template_content_blocks.map(&:to_s)
          content_blocks.where.not(name: registered_names).destroy_all
        end

        def template_in_registered_templates
          return if template.blank?

          unless self.class.templates.map(&:id).include?(template)
            errors.add(:template, "is not a registered template")
          end
        end
      end
    end
  end
end
