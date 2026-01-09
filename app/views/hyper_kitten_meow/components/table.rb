# frozen_string_literal: true

module HyperKittenMeow
  class Components::Table < Components::Base
    include Phlex::Rails::Helpers::Request
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::URLFor

    Column = Struct.new(:name, :method_name, :sort_key, :block, :sortable, :options, :header_options)

    attr_writer :sort_path

    def initialize(collection: [], requested_columns: [], sortable_column_default: false, sort_path: nil, **options)
      @collection = collection
      @sortable_column_default = sortable_column_default
      @columns = []
      @requested_columns = requested_columns
      @footer_block = nil
      @sort_path = sort_path

      @table_options = options.fetch(:table, {})
      @thead_options = options.fetch(:thead, {})
      @tbody_options = options.fetch(:tbody, {})
      @tr_options = options.fetch(:tr, {})
      @th_options = options.fetch(:th, {})
    end

    def column(name, method_name: nil, sort_key: nil, sortable: @sortable_column_default, header_options: {}, **options, &block)
      if method_name.nil?
        method_name = name.to_s.parameterize.underscore
        name = name.to_s.titleize
      end
      sort_key = method_name if sort_key.blank?
      @columns << Column.new(name, method_name, sort_key, block, sortable, options, header_options)
    end

    def footer(&block)
      @footer_block = block
    end

    def header_sort_url(column, query_params)
      if query_params.dig(:order, column.sort_key) == "desc"
        link_to(column.name, merged_sort_path(query_params.merge(order: {column.sort_key => :asc})), data: {turbo_stream: true})
      else
        link_to(column.name, merged_sort_path(query_params.merge(order: {column.sort_key => :desc})), data: {turbo_stream: true})
      end
    end

    def merged_sort_path(query_params)
      if @sort_path.present?
        @sort_path + "?" + query_params.to_query
      else
        url_for(query_params)
      end
    end

    def view_template(&)
      vanish(&)

      div(class: "table-responsive") do
        table(**mix({class: "table table-centered"}, @table_options)) do
          render_header
          render_body
        end
      end

      @footer_block&.call
    end

    private

    def visible_columns
      return @columns if @requested_columns.empty?

      @columns.select { |column| @requested_columns.include?(column.name) }
    end

    def render_header
      thead(**@thead_options) do
        tr do
          visible_columns.each do |column|
            header_options = @th_options.merge(column.header_options)
            if column.sortable
              th(**header_options) do
                header_sort_url(column, request.query_parameters)
              end
            else
              th(**header_options) { column.name }
            end
          end
        end
      end
    end

    def render_body
      tbody(**@tbody_options) do
        @collection.each do |record|
          tr(**@tr_options) do
            visible_columns.each do |column|
              if column.block
                td(**column.options) { column.block.call(record) }
              else
                td(**column.options) { record.public_send(column.method_name) }
              end
            end
          end
        end
      end
    end
  end
end
