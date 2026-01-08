# frozen_string_literal: true

require "rails_helper"

RSpec.describe HyperKittenMeow::Components::Table, type: :view do
  # Helper to render Phlex components in tests
  def render_component(component)
    render component
    rendered
  end

  describe "rendering a table" do
    it "with defaults" do
      component = described_class.new(collection: []) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_css("div.table-responsive")
      expect(rendered).to have_css("table.table.table-centered")
      within("table") do
        within "thead" do
          expect(rendered).to have_css("th", text: "Name")
        end
        within "tbody" do
          expect(rendered).not_to have_css("tr")
        end
      end
    end

    it "renders collection items" do
      user = build(:user, name: "Hyper Kitten")
      component = described_class.new(collection: [user]) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      within("table tbody tr") do
        expect(rendered).to have_css("td", text: "Hyper Kitten")
      end
    end

    it "with custom column options" do
      user = build(:user, name: "Hyper Kitten")
      component = described_class.new(collection: [user]) do |table|
        table.column(:name, sortable: false, class: "custom-class", header_options: {class: "header-class"})
      end

      render_component(component)

      within("table") do
        within "thead tr" do
          expect(rendered).to have_selector("th.header-class", text: "Name")
        end
        within "tbody tr" do
          expect(rendered).to have_selector("td.custom-class", text: "Hyper Kitten")
        end
      end
    end

    it "with custom table options" do
      component = described_class.new(collection: [], table: {class: "custom-table"}) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_selector("table.custom-table")
    end

    it "with custom tbody options" do
      component = described_class.new(collection: [], tbody: {class: "custom-tbody"}) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_selector("table tbody.custom-tbody")
    end

    it "with custom thead options" do
      component = described_class.new(collection: [], thead: {class: "custom-thead"}) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_selector("table thead.custom-thead")
    end

    it "with custom tr options applied to body rows" do
      user = build(:user, name: "Test")
      component = described_class.new(collection: [user], tr: {class: "custom-tr"}) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_selector("table tbody tr.custom-tr")
    end

    it "with custom th options" do
      component = described_class.new(collection: [], th: {class: "custom-th"}) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      expect(rendered).to have_selector("table thead tr th.custom-th")
    end

    it "with custom column content via block" do
      user = build(:user, name: "Test User")
      component = described_class.new(collection: [user]) do |table|
        table.column(:name, sortable: false)
        table.column("Actions", sortable: false) do |record|
          "Edit #{record.name}"
        end
      end

      render_component(component)

      within("table thead tr") do
        expect(rendered).to have_css("th", text: "Actions")
      end
      within("table tbody tr") do
        expect(rendered).to have_css("td", text: "Edit Test User")
      end
    end

    it "renders only the specified columns when requested" do
      component = described_class.new(collection: [], requested_columns: ["Name"]) do |table|
        table.column(:name, sortable: false)
        table.column(:email, sortable: false)
      end

      render_component(component)

      within("table thead tr") do
        expect(rendered).to have_selector("th", text: "Name")
        expect(rendered).not_to have_selector("th", text: "Email")
      end
    end

    it "with sortable columns" do
      component = described_class.new(collection: [], sort_path: "/test") do |table|
        table.column(:name, sortable: true)
        table.column(:email, sortable: true)
      end

      render_component(component)

      within("table thead") do
        expect(rendered).to have_link("Name")
        expect(rendered).to have_link("Email")
      end
    end

    it "with global sortable default set to false" do
      component = described_class.new(collection: [], sortable_column_default: false) do |table|
        table.column(:name)
      end

      render_component(component)

      within("table thead tr") do
        expect(rendered).to have_selector("th", text: "Name")
        expect(rendered).not_to have_link("Name")
      end
    end

    it "with global sortable default set to true" do
      component = described_class.new(collection: [], sortable_column_default: true, sort_path: "/test") do |table|
        table.column(:name)
      end

      render_component(component)

      within("table thead") do
        expect(rendered).to have_link("Name")
      end
    end

    it "with a footer rendered outside the table" do
      component = described_class.new(collection: []) do |table|
        table.column(:name, sortable: false)
        table.footer do
          table.div(class: "footer-content") { "Footer Text" }
        end
      end

      render_component(component)

      expect(rendered).to have_css("div.footer-content", text: "Footer Text")
      expect(rendered).not_to have_selector("table", text: "Footer Text")
    end

    it "with multiple records" do
      users = [
        build(:user, name: "Alice"),
        build(:user, name: "Bob")
      ]
      component = described_class.new(collection: users) do |table|
        table.column(:name, sortable: false)
      end

      render_component(component)

      within("table tbody") do
        expect(rendered).to have_css("tr", count: 2)
        expect(rendered).to have_css("td", text: "Alice")
        expect(rendered).to have_css("td", text: "Bob")
      end
    end

    it "titleizes column names from symbols" do
      component = described_class.new(collection: []) do |table|
        table.column(:created_at, sortable: false)
      end

      render_component(component)

      within("table thead") do
        expect(rendered).to have_css("th", text: "Created At")
      end
    end
  end
end
