module HyperKittenMeow
  module Concerns
    module Models
      module MenuItem
        extend ActiveSupport::Concern

        # A path on this site, or an absolute http(s) URL. Also keeps javascript: and other
        # schemes, and protocol-relative //host URLs, out of every visitor's href.
        URL_FORMAT = %r{\A(/(?!/)|https?://\S)}i

        included do
          belongs_to :menu, class_name: "HyperKittenMeow::Menu", inverse_of: :items, touch: true
          belongs_to :parent, class_name: "HyperKittenMeow::MenuItem", optional: true, inverse_of: :children
          belongs_to :page, class_name: "HyperKittenMeow::Page", optional: true, inverse_of: :menu_items
          has_many :children,
            -> { order(:position, :id) },
            class_name: "HyperKittenMeow::MenuItem",
            foreign_key: :parent_id,
            inverse_of: :parent,
            validate: false

          normalizes :label, :url, with: ->(value) { value.strip.presence }

          validates :position, numericality: {only_integer: true, greater_than_or_equal_to: 0}
          validates :label, length: {maximum: 255}
          validates :label, presence: {message: "is required for a URL"}, if: :url?
          validates :url, length: {maximum: 2048},
            format: {with: URL_FORMAT, message: "must start with / or http:// or https://"},
            allow_nil: true
          validates :page, presence: {message: "no longer exists"}, if: :page_id?
          validate :links_to_one_target
          validate :parent_in_same_menu
          validate :parent_chain_is_not_a_loop
        end

        def page_deleted?
          page_id.nil? && url.nil? && page_deleted_in_database?
        end

        def display_label
          label.presence || page&.title
        end

        private

        def links_to_page?
          page_id? || page.present?
        end

        def page_deleted_in_database?
          persisted? && page_id_in_database.nil? && url_in_database.nil?
        end

        def links_to_one_target
          if links_to_page? && url?
            errors.add(:base, "Link to a page or a URL, not both")
          elsif !links_to_page? && !url?
            errors.add(:base, page_deleted_in_database? ? "Its page was deleted: choose another page or remove it" : "Choose a page or enter a URL")
          end
        end

        def parent_in_same_menu
          return if parent.nil?

          errors.add(:parent, "must be in the same menu") unless parent.menu_id == menu_id
        end

        def parent_chain_is_not_a_loop
          seen = [self]
          node = parent
          while node
            if seen.any? { |item| item.equal?(node) || (item.persisted? && item == node) }
              errors.add(:parent, "can't be the item itself or one of the items under it")
              return
            end
            seen << node
            node = node.parent
          end
        end
      end
    end
  end
end
