module Features
  module Quill
    def fill_in_quill_editor(name, with:)
      quill_input = find(:xpath, "//h4[starts-with(text(), '#{name}')]/following-sibling::div").find("div[contenteditable='true'].ql-editor")
      quill_input.native.clear
      quill_input.send_keys with
    end
  end
end
