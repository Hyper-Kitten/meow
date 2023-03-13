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
          ["bold", "italic", "underline", "strike"],
          [{ list: "ordered" }, { list: "bullet" }],
          ["link"],
          ["clean"],
        ],
      },
      theme: "snow",
    });

    const form = this.element.closest("form");
    form.addEventListener("submit", () => {
      this.hiddenInputTarget.value = quillEditor.root.innerHTML;
    });
  }
}
