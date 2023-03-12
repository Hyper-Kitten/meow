import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["contentBlock", "links", "template"];

  add(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
    this.linksTarget.insertAdjacentHTML('beforebegin', content);
  }

  remove(event) {
    event.preventDefault();
    const wrapper = event.target.closest('.content-block');
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove();
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1";
      wrapper.style.display = "none";
    }
  }
}
