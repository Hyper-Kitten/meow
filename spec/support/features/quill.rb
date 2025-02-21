module Features
  module Quill
    def fill_in_quill_editor(name, with:)
      xpath = "//h4[text()='#{name}']/following-sibling::div | //label[starts-with(text(), '#{name}')]/following-sibling::div"
      quill_input = find(:xpath, xpath).find("div[contenteditable='true'].ql-editor")
      quill_input.native.clear
      quill_input.send_keys with
    end
  end
end
