# frozen_string_literal: true

module HyperKittenMeow
  class Components::Form < Components::Base
    include Phlex::Rails::Helpers::FormWith

    def initialize(**options)
      @options = options
      @model = options[:model]
    end

    def view_template(&block)
      render_errors if @model&.errors&.any?

      form_options = mix(
        {
          local: true,
          data: {turbo: false},
          html: {class: "needs-validation", novalidate: true}
        },
        @options
      )

      form_with(**form_options) do |f|
        @form = f
        yield(self) if block_given?
      end
    end

    def text_field(attribute, label: nil, placeholder: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.text_field(
          attribute,
          **field_options(attribute, placeholder: placeholder, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def email_field(attribute, label: nil, placeholder: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.email_field(
          attribute,
          **field_options(attribute, placeholder: placeholder, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def password_field(attribute, label: nil, placeholder: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.password_field(
          attribute,
          **field_options(attribute, placeholder: placeholder, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def text_area(attribute, label: nil, placeholder: nil, required: false, rows: 3, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.text_area(
          attribute,
          **field_options(attribute, placeholder: placeholder, required: required, rows: rows, **options)
        )
        error_message(attribute)
      end
    end

    def rich_text_area(attribute, label: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        div(class: "quill-editor-wrapper", data: {controller: "quill"}) do
          @form.hidden_field(attribute, data: {quill_target: "hiddenInput"})
          div(data: {quill_target: "quillContainer"})
        end
        error_message(attribute)
      end
    end

    def select(attribute, choices, label: nil, required: false, include_blank: nil, **options)
      field_wrapper(attribute, label: label, required: required) do
        select_options = {}
        select_options[:include_blank] = include_blank unless include_blank.nil?

        @form.select(
          attribute,
          choices,
          select_options,
          **field_options(attribute, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def collection_select(attribute, collection, value_method: :id, text_method: :to_label, label: nil, required: false, include_blank: nil, **options)
      field_wrapper(attribute, label: label, required: required) do
        select_options = {}
        select_options[:include_blank] = include_blank unless include_blank.nil?

        formatted_choices = collection.map do |item|
          [item.public_send(text_method), item.public_send(value_method)]
        end

        @form.select(
          attribute,
          formatted_choices,
          select_options,
          **field_options(attribute, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def collection_check_boxes(attribute, collection, value_method: :id, text_method: :to_label, label: nil, **options)
      field_wrapper(attribute, label: label, required: false) do
        @form.collection_check_boxes(attribute, collection, value_method, text_method) do |b|
          div(class: "form-check") do
            render b.check_box(class: "form-check-input")
            render b.label(class: "form-check-label")
          end
        end
        error_message(attribute)
      end
    end

    def check_box(attribute, label: nil, **options)
      field_wrapper(attribute, label: false, required: false) do
        div(class: "form-check") do
          @form.check_box(attribute, **mix({class: "form-check-input"}, options))
          @form.label(attribute, class: "form-check-label") { label || attribute.to_s.titleize }
        end
        error_message(attribute)
      end
    end

    def file_field(attribute, label: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.file_field(
          attribute,
          **field_options(attribute, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def datetime_local_field(attribute, label: nil, required: false, **options)
      field_wrapper(attribute, label: label, required: required) do
        @form.datetime_local_field(
          attribute,
          **field_options(attribute, required: required, **options)
        )
        error_message(attribute)
      end
    end

    def submit(text = nil, **options)
      @form.submit(text, **mix({class: "btn btn-primary"}, options))
    end

    def fields_for(...)
      @form.fields_for(...)
    end

    private

    def field_wrapper(attribute, label: nil, required: false, &block)
      div(class: "mb-3") do
        if label != false
          div(class: "d-flex align-items-center gap-1") do
            field_label(attribute, label: label)
            span(class: "text-danger") { "*" } if required
          end
        end
        block.call
      end
    end

    def field_label(attribute, label: nil)
      label_text = label || attribute.to_s.humanize
      @form.label(attribute, label_text, class: "form-label mb-0")
    end

    def field_options(attribute, **options)
      class_names = ["form-control"]
      class_names << "is-invalid" if has_errors?(attribute)

      mix(options, class: class_names)
    end

    def error_message(attribute)
      return unless has_errors?(attribute)

      div(class: "invalid-feedback d-block") do
        @model.errors[attribute].join(", ")
      end
    end

    def has_errors?(attribute)
      @model&.errors&.[](attribute)&.any?
    end

    def render_errors
      return unless @model

      div(class: "alert alert-danger") do
        h4(class: "alert-heading") { "Please correct the following errors:" }
        ul do
          @model.errors.full_messages.each do |message|
            li { message }
          end
        end
      end
    end
  end
end
