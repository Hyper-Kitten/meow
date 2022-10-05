import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["menuItem", "links", "template"];

  connect() {
    console.log("Hello from Sortable", this.application);
    this.sortable = Sortable.create(this.element, {
      onEnd: this.updateOrder.bind(this)
    })
  }

  addMenuItem(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
    this.linksTarget.insertAdjacentHTML('beforebegin', content);
    this.updateOrder();
  }

  removeMenuItem(event) {
    event.preventDefault();
    const wrapper = event.target.closest('.menu-item');
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove();
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1";
      wrapper.style.display = "none";
    }
    this.updateOrder();
  }

  updateOrder(event) {
    console.log(this.menuItemTargets);
    this.menuItemTargets.forEach((menuItem, index) => {
      menuItem.querySelector("input[name*='position']").value = index + 1;
    });
  }
}
