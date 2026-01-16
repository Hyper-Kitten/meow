import { Controller } from "@hotwired/stimulus"
import Quill from "quill";

export default class extends Controller {
  static targets = ["quillContainer", "hiddenInput"];

  connect() {
    const quillEditor = new Quill(this.quillContainerTarget, {
      modules: {
        toolbar: [
          [{ header: [1, 2, 3, 4, 5, false] }],
          [{ color: [] }],
          ["bold", "italic", "underline", "strike", "code"],
          ["blockquote", "code-block"],
          [{ list: "ordered" }, { list: "bullet" }],
          ["link"],
          ["clean"],
        ],
      },
      theme: "snow",
    });

    const form = this.element.closest("form");
    form.addEventListener("submit", () => {
      // Workaround for Quill 2.0.3+ converting spaces to &nbsp;
      // See: https://github.com/slab/quill/issues/4509
      const html = quillEditor.root.innerHTML;
      this.hiddenInputTarget.value = html.replaceAll(/((?:&nbsp;)*)\&nbsp;/g, '$1 ');
    });
  }
}
