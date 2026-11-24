# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Menus::Edit < Views::Admin::Base
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::Pluralize

    NEW_KEY = "NEW_RECORD"
    EXTERNAL_URL = Menu::TreeBuilder::EXTERNAL_URL

    def initialize(menu:, definition:, pages:, menu_count:)
      @menu = menu
      @definition = definition
      @pages = pages
      @menu_count = menu_count
      @rows = menu.editor_rows
    end

    def view_template
      section(class: "mw-menu-editor", data: {controller: "menu-tree", menu_tree_max_depth_value: max_depth}) do
        render Components::PageHeader.new(title: @definition.label, eyebrow: eyebrow) do
          if @menu_count > 1
            render Components::LinkButton.new(hyper_kitten_meow.admin_menus_path, "All Menus", scheme: :outline_secondary, icon: "chevron-left")
          end
          button(type: "button", class: "btn btn-outline", data: {action: "menu-tree#add"}) do
            render Components::Icon.new("plus", size: :lg)
            plain "Add Item"
          end
        end

        form_with(
          url: hyper_kitten_meow.admin_menu_path(@definition.key),
          method: :patch,
          local: true,
          data: {
            turbo: false,
            menu_tree_target: "form",
            action: "input->menu-tree#fieldChanged change->menu-tree#fieldChanged submit->menu-tree#submit"
          }
        ) do
          input(type: "hidden", name: "menu[submitted]", value: "1")
          input(type: "hidden", name: "menu[version]", value: @menu.edit_version)

          p(class: "mw-menu-note mw-menu-note--hint") do
            plain "Drag "
            render Components::Icon.new("grip-vertical", size: :xs, role: "img", aria_label: "the grip")
            plain hint
          end

          div(class: "mw-menu-empty", hidden: @rows.any?, data: {menu_tree_target: "empty"}) do
            p { "No items yet." }
            button(type: "button", class: "btn btn-outline", data: {action: "menu-tree#add"}) do
              render Components::Icon.new("plus", size: :lg)
              plain "Add Item"
            end
          end

          ul(class: "mw-menu-tree", data: {menu_tree_target: "root"}) do
            @rows.each { |row| render_row(row) }
          end

          div(hidden: true, data: {menu_tree_target: "removed"})

          template(data: {menu_tree_target: "template"}) do
            render_row(Menu::TreeUpdate::Row.new(key: NEW_KEY, item: MenuItem.new, errors: [], children: [], depth: 1), open: true)
          end

          div(class: "mw-menu-footer") do
            span(class: "ds-eyebrow mw-menu-footer__dirty", hidden: !@menu.tree_errors.any?, data: {menu_tree_target: "dirty"}) do
              span(class: "mw-menu-footer__dot", aria_hidden: "true")
              plain "Unsaved changes"
            end
            div(class: "mw-btn-group") do
              a(href: hyper_kitten_meow.edit_admin_menu_path(@definition.key), class: "btn btn-outline", data: {turbo: false, action: "menu-tree#discard"}) { "Discard" }
              button(type: "submit", class: "btn btn-primary") { "Save Menu" }
            end
          end
        end
      end
    end

    private

    def max_depth = @definition.depth

    def eyebrow
      levels = (max_depth == 1) ? "1 level" : "Up to #{max_depth} levels"
      "#{levels} · #{pluralize(count_rows(@rows), "item")}"
    end

    def hint
      if max_depth > 1
        " to reorder or nest. Use ‹ › to move an item out of, or into, the item above it."
      else
        " to reorder."
      end
    end

    def count_rows(rows)
      rows.sum { |row| 1 + count_rows(row.children) }
    end

    def level_buttons?
      return @level_buttons if defined?(@level_buttons)

      @level_buttons = max_depth > 1 || @rows.any? { |row| row.children.any? }
    end

    def render_row(row, open: false)
      item = row.item
      key = row.key
      name = ->(field) { "menu[items][#{key}][#{field}]" }
      dom = ->(field) { "menu_item_#{key}_#{field}" }
      row_label = item.display_label.presence || "New item"
      open ||= row.errors.any?

      li(class: "mw-menu-item", id: dom.call("row"), data: {menu_tree_target: "item", key: key}) do
        div(class: ["mw-menu-row", ("has-errors" if row.errors.any?)]) do
          span(class: "mw-menu-row__grip", title: "Drag to reorder") do
            render Components::Icon.new("grip-vertical", size: :sm)
          end
          span(class: "mw-menu-row__label", data: {role: "label"}) { row_label }
          render_target(item)
          render_badges(row)

          if level_buttons?
            button(type: "button", class: "btn mw-iconbtn", aria_label: "Move out a level", title: "Move out a level", data: {role: "outdent", action: "menu-tree#outdent"}) do
              render Components::Icon.new("chevron-left", size: :sm)
            end
            button(type: "button", class: "btn mw-iconbtn", aria_label: "Move into the item above", title: "Move into the item above", data: {role: "indent", action: "menu-tree#indent"}) do
              render Components::Icon.new("chevron-right", size: :sm)
            end
          end
          button(
            type: "button",
            class: "btn btn-sm btn-ghost",
            aria_expanded: open.to_s,
            aria_controls: dom.call("form"),
            data: {role: "toggle", action: "menu-tree#toggle"}
          ) { open ? "Close" : "Edit" }
          button(type: "button", class: "btn mw-iconbtn", aria_label: "Remove #{row_label}", title: "Remove", data: {role: "remove", action: "menu-tree#remove"}) do
            render Components::Icon.new("trash-2", size: :sm)
          end
        end

        if row.errors.any?
          ul(class: "mw-menu-row__errors") { row.errors.each { |message| li { message } } }
        end

        input(type: "hidden", name: name.call(:id), value: item.id)
        input(type: "hidden", name: name.call(:parent_key), value: row.parent_key, data: {role: "parent-key"})
        input(type: "hidden", name: name.call(:position), value: item.position, data: {role: "position"})
        input(type: "hidden", name: name.call(:_destroy), value: "0", data: {role: "destroy"})

        render_form(item, name: name, dom: dom, open: open)

        ul(class: "mw-menu-tree__children", data: {menu_tree_target: "list"}) do
          row.children.each { |child| render_row(child) }
        end
      end
    end

    def render_target(item)
      url_item = item.url.present?
      span(class: "mw-menu-row__target") do
        span(data: {role: "target-page"}, hidden: url_item || item.page_id.nil?) do
          render Components::Icon.new("file-text", size: :sm)
          span(data: {role: "page-title"}) { item.page&.title }
        end
        span(data: {role: "target-url"}, hidden: !url_item) do
          render Components::Icon.new("link", size: :sm)
          span(class: "ds-mono", data: {role: "url-text"}) { item.url }
          span(data: {role: "external"}, hidden: !item.url.to_s.match?(EXTERNAL_URL)) do
            render Components::Icon.new("external-link", size: :xs, role: "img", aria_label: "Opens another site")
          end
        end
        span(class: "mw-menu-row__untargeted", data: {role: "target-none"}, hidden: url_item || item.page_id.present?) do
          item.page_deleted? ? "" : "Not linked yet"
        end
      end
    end

    def render_badges(row)
      item = row.item
      if item.page_deleted?
        span(class: "mw-badge mw-badge--danger") { "Page deleted" }
      end
      span(
        class: "mw-badge mw-badge--warning",
        title: "Hidden on the site until the page is published. Items under it are hidden too.",
        hidden: !(item.page && !item.page.published?),
        data: {role: "badge-hidden"}
      ) { "Hidden · page is a draft" }
      span(
        class: "mw-badge mw-badge--danger",
        title: "This menu allows #{pluralize(max_depth, "level")}. Move the item up a level to save the menu.",
        hidden: !row.too_deep?(max_depth),
        data: {role: "badge-too-deep"}
      ) { "Too deep" }
    end

    def render_form(item, name:, dom:, open:)
      link_type = item.url.present? ? "url" : "page"

      div(class: "mw-menu-form", id: dom.call("form"), hidden: !open) do
        div(class: "mw-menu-form__field") do
          label(class: "form-label", for: dom.call("label")) { "Label" }
          input(
            type: "text",
            class: "form-control",
            id: dom.call("label"),
            name: name.call(:label),
            value: item.label,
            placeholder: item.page&.title,
            maxlength: 255,
            data: {role: "label-input"}
          )
          div(class: "mw-menu-form__help") { "Leave blank to use the page title. Required for a URL." }
        end

        fieldset(class: "mw-menu-form__field") do
          legend(class: "form-label") { "Links to" }
          div(class: "mw-segmented") do
            [["page", "A page"], ["url", "A URL"]].each do |value, text|
              label(class: "mw-segmented__option") do
                input(type: "radio", name: name.call(:link_type), value: value, checked: link_type == value, data: {role: "link-type"})
                span { text }
              end
            end
          end
        end

        div(class: "mw-menu-form__field mw-menu-form__field--wide", data: {link_field: "page"}, hidden: link_type != "page") do
          label(class: "form-label", for: dom.call("page_id")) { "Page" }
          select(class: "form-select", id: dom.call("page_id"), name: name.call(:page_id), data: {role: "page-select"}) do
            option(value: "") { "Choose a page…" }
            @pages.each do |page|
              option(value: page.id, selected: page.id == item.page_id, data: {published: page.published?.to_s, title: page.title}) do
                page.published? ? page.title : "#{page.title} (draft)"
              end
            end
          end
        end

        div(class: "mw-menu-form__field mw-menu-form__field--wide", data: {link_field: "url"}, hidden: link_type != "url") do
          label(class: "form-label", for: dom.call("url")) { "URL" }
          input(
            type: "text",
            class: "form-control mono",
            id: dom.call("url"),
            name: name.call(:url),
            value: item.url,
            placeholder: "/news or https://example.org",
            inputmode: "url",
            data: {role: "url-input"}
          )
          div(class: "mw-menu-form__help") { "A path on this site, like /news, or a full https:// address." }
        end
      end
    end
  end
end
