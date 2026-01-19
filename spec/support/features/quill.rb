module Features
  module Quill
    def fill_in_quill_editor(name, with:)
      # Use normalize-space for exact text match to avoid partial matches like "Test Block" matching "Test Block Two"
      xpath = "//h4[normalize-space(text())='#{name}']/following-sibling::div | //label[normalize-space(text())='#{name}']/../following-sibling::div"
      quill_input = find(:xpath, xpath).find("div[contenteditable='true'].ql-editor")
      quill_input.native.clear
      quill_input.send_keys with
    end

    def quill_editor_content(name)
      xpath = "//h4[normalize-space(text())='#{name}']/following-sibling::div | //label[normalize-space(text())='#{name}']/../following-sibling::div"
      quill_input = find(:xpath, xpath).find("div[contenteditable='true'].ql-editor")
      quill_input.text
    end
  end
end
