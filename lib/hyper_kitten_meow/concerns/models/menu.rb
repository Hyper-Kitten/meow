module HyperKittenMeow
  module Concerns
    module Models
      module Menu
        extend ActiveSupport::Concern

        # Bump whenever the shape of Menu::Item changes, so an upgrade never reads trees
        # cached in the old shape.
        TREE_VERSION = 1

        included do
          has_many :items,
            -> { order(:position, :id) },
            class_name: "HyperKittenMeow::MenuItem",
            inverse_of: :menu

          validates :key, presence: true

          after_commit { HyperKittenMeow::Current.menu_trees = nil }
        end

        class_methods do
          def fetch(key)
            definition = HyperKittenMeow.menus.fetch(key.to_sym) do
              raise ArgumentError, "No menu #{key.inspect} is declared in config.hyper_kitten_meow.menus " \
                                   "(declared: #{HyperKittenMeow.menus.keys.map(&:inspect).join(", ").presence || "none"})"
            end

            trees = (HyperKittenMeow::Current.menu_trees ||= {})
            trees[definition.key] ||= cached_tree(definition)
          end

          def for_definition!(definition)
            create_or_find_by!(key: definition.key.to_s)
          end

          private

          def cached_tree(definition)
            menu = find_by(key: definition.key.to_s)
            return HyperKittenMeow::Menu::Tree.new(key: definition.key, items: [].freeze) unless menu

            cache_key = ["meow/menu", TREE_VERSION, definition.depth, menu.cache_key_with_version]
            Rails.cache.fetch(cache_key) do
              HyperKittenMeow::Menu::TreeBuilder.new(menu, definition).call
            end
          end
        end

        def definition
          HyperKittenMeow.menus[key.to_sym]
        end

        def replace_tree(rows)
          @tree_update = HyperKittenMeow::Menu::TreeUpdate.new(self, rows)
          @tree_update.save
        end

        # The rows to show in the admin editor: the ones last posted to replace_tree,
        # or the saved items.
        def editor_rows
          @tree_update&.rows || HyperKittenMeow::Menu::TreeUpdate.rows_for_items(items.includes(:page).to_a)
        end

        def tree_errors
          @tree_update&.error_messages || []
        end
      end
    end
  end
end
