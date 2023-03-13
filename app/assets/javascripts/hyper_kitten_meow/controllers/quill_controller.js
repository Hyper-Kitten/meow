import { Controller } from "@hotwired/stimulus"
import Quill from "quill";

export default class extends Controller {
  static targets = ["quillContainer", "hiddenInput"];

  connect() {
    const quillEditor = new Quill(this.quillContainerTarget, {
      theme: "snow",
    });

    const form = this.element.closest("form");
    form.addEventListener("submit", () => {
      this.hiddenInputTarget.value = quillEditor.root.innerHTML;
    });
  }
}
