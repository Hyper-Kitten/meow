class QuillInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] ||= input_type
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    hidden_field = @builder.hidden_field(attribute_name, value: nil, data: { "quill-target": "hiddenInput" })
    container_data = { "quill-target": "quillContainer" }.merge(merged_input_options.delete(:data) || {})
    quill_container = template.content_tag(:div, template.raw(object.public_send(attribute_name)), class: "quill-container", data: container_data)

    error_class = has_errors? ? "is-invalid" : ""

    template.content_tag(:div, data: { controller: "quill" }, class: error_class) do
      hidden_field + quill_container
    end
  end

  def input_type
    :text
  end
end
