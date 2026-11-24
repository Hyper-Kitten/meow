# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::Menus::Index < Views::Admin::Base
    include Phlex::Rails::Helpers::Pluralize

    def initialize(definitions:, item_counts:)
      @definitions = definitions
      @item_counts = item_counts
    end

    def view_template
      section(class: "menus") do
        render Components::PageHeader.new(title: "Menus", eyebrow: "#{pluralize(@definitions.size, "menu")} · set by the site")

        if @definitions.empty?
          p(class: "mw-menu-note") do
            plain "This site doesn't declare any menus yet. A developer adds them in "
            code { "config.hyper_kitten_meow.menus" }
            plain "."
          end
        else
          render Components::Table.new(collection: @definitions, tr: {class: "menu"}) do |t|
            t.column "Name", class: "cell-title", method_name: :label
            t.column "Key", class: "cell-mono", method_name: :key
            t.column "Levels", class: "cell-mono cell-num", header_options: {class: "cell-num"}, method_name: :depth
            t.column "Items", class: "cell-mono cell-num", header_options: {class: "cell-num"} do |definition|
              @item_counts.fetch(definition.key, 0).to_s
            end
            t.column "", header_options: {class: "col-actions"}, class: "col-actions" do |definition|
              render Components::LinkButton.new(
                hyper_kitten_meow.edit_admin_menu_path(definition.key),
                "Edit",
                scheme: :sm_outline_info,
                icon: "pen-line",
                aria: {label: "Edit #{definition.label}"}
              )
            end
          end

          p(class: "mw-menu-note") do
            "Which menus exist, and how many levels each allows, is set in the site's code. Ask a developer to add one."
          end
        end
      end
    end
  end
end
