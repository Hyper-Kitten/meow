module HyperKittenMeow
  class Table
    include HyperKittenTables::Concerns::Table

    def_delegators :@view_context, :link_to

    Column = Struct.new(:name, :method_name, :sort_key, :block, :sortable, :options)
    def header_sort_url(column, query_params)
      if query_params.dig(:order, column.sort_key) == "desc"
        link_to(column.name, query_params.merge(order: { column.sort_key => :asc }), data: { "turbo-stream": true })
      else
        link_to(column.name, query_params.merge(order: { column.sort_key => :desc }), data: { "turbo-stream": true })
      end
    end

    private

    def render_table
      table_options = {
        class: "table table-centered"
      }.merge(@table_options)

      content_tag(:div, class: "table-responsive") do
        content_tag(:table, table_options) do
          render_header + render_body
        end + render_footer
      end
    end
  end
end
