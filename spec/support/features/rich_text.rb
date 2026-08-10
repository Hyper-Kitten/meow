module Features
  module RichText
    def fill_in_rich_text_editor(name, with:)
      editor = rich_text_editor(name)
      editor.click
      editor.send_keys [:control, "a"], :backspace
      editor.send_keys with
    end

    def rich_text_editor_content(name)
      rich_text_editor(name).text
    end

    private

    def rich_text_editor(name)
      # Lexxy renders a <lexxy-editor> custom element whose editable surface is a
      # contenteditable div. Locate it via the nearest labelling element so the
      # same helper works for both standalone fields (label) and content blocks (h4).
      label = find(:xpath, ".//label[normalize-space(.)='#{name}'] | .//h4[normalize-space(.)='#{name}']")
      container = label.find(:xpath, "ancestor::*[.//lexxy-editor][1]")
      container.find("lexxy-editor [contenteditable='true']")
    end
  end
end
