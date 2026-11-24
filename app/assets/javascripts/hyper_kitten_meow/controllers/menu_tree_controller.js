import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

const ITEM = "li.mw-menu-item"
const EXTERNAL_URL = /^https?:\/\//i

export default class extends Controller {
  static targets = ["root", "template", "removed", "empty", "dirty"]
  static values = { maxDepth: Number }

  connect() {
    this.sortables = []
    this.nextKey = Date.now()

    this.initSortable(this.rootTarget)
    this.rootTarget.querySelectorAll("ul.mw-menu-tree__children").forEach((list) => this.initSortable(list))
    this.refresh()

    this.warnBeforeUnload = (event) => {
      if (!this.dirty) return
      event.preventDefault()
      event.returnValue = ""
    }
    this.warnBeforeVisit = (event) => {
      if (this.dirty && !window.confirm("Leave without saving your menu changes?")) event.preventDefault()
    }
    window.addEventListener("beforeunload", this.warnBeforeUnload)
    document.addEventListener("turbo:before-visit", this.warnBeforeVisit)
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.warnBeforeUnload)
    document.removeEventListener("turbo:before-visit", this.warnBeforeVisit)
    this.sortables.forEach((sortable) => sortable.destroy())
  }

  add() {
    const key = String(-(++this.nextKey))
    const html = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", key)
    this.rootTarget.insertAdjacentHTML("beforeend", html)

    const item = this.rootTarget.lastElementChild
    this.initSortable(item.querySelector(":scope > ul.mw-menu-tree__children"))
    this.changed()
    item.querySelector("[data-role='label-input']")?.focus()
  }

  indent(event) {
    const item = this.itemFor(event)
    const above = item.previousElementSibling
    if (!above) return

    const list = this.childList(above)
    if (!this.fits(item, list)) return

    list.appendChild(item)
    this.changed()
    this.refocus(item, "indent")
  }

  outdent(event) {
    const item = this.itemFor(event)
    const parent = this.parentItem(item)
    if (!parent) return

    parent.after(item)
    this.changed()
    this.refocus(item, "outdent")
  }

  toggle(event) {
    const item = this.itemFor(event)
    const form = item.querySelector(":scope > .mw-menu-form")
    const button = event.currentTarget
    form.hidden = !form.hidden
    button.textContent = form.hidden ? "Edit" : "Close"
    button.setAttribute("aria-expanded", String(!form.hidden))
    if (!form.hidden) form.querySelector("input, select")?.focus()
  }

  remove(event) {
    const item = this.itemFor(event)
    const nested = item.querySelectorAll(ITEM).length
    const name = item.querySelector("[data-role='label']").textContent.trim()

    if (nested > 0) {
      const what = nested === 1 ? "the item under it" : `the ${nested} items under it`
      if (!window.confirm(`Remove “${name}” and ${what}?`)) return
    }

    if (this.persisted(item)) {
      item.querySelectorAll("[data-role='destroy']").forEach((input) => (input.value = "1"))
      this.removedTarget.appendChild(item)
    } else {
      item.remove()
    }
    this.changed()
  }

  fieldChanged(event) {
    const item = event.target.closest(ITEM)
    if (!item) return

    if (event.target.matches("[data-role='link-type']")) this.showLinkFields(item)
    this.updateSummary(item)
    this.dirty = true
  }

  submit() {
    this.items().forEach((item) => {
      const parent = this.parentItem(item)
      this.field(item, "parent-key").value = parent ? parent.dataset.key : ""
      this.field(item, "position").value = Array.from(item.parentElement.children).indexOf(item)
    })
    this.dirty = false
  }

  discard() {
    this.dirty = false
  }

  get dirty() {
    return !this.dirtyTarget.hidden
  }

  set dirty(value) {
    this.dirtyTarget.hidden = !value
  }

  initSortable(list) {
    this.sortables.push(
      Sortable.create(list, {
        group: "menu-tree",
        handle: ".mw-menu-row__grip",
        animation: 150,
        fallbackOnBody: true,
        swapThreshold: 0.65,
        emptyInsertThreshold: 10,
        onStart: () => this.element.classList.add("is-dragging"),
        onEnd: () => {
          this.element.classList.remove("is-dragging")
          this.changed()
        },
        onMove: (event) => this.fits(event.dragged, event.to)
      })
    )
  }

  fits(item, list) {
    return this.listDepth(list) + this.height(item) - 1 <= this.maxDepthValue
  }

  listDepth(list) {
    let depth = 1
    let item = list.closest(ITEM)
    while (item && this.rootTarget.contains(item)) {
      depth++
      item = this.parentItem(item)
    }
    return depth
  }

  height(item) {
    const children = Array.from(this.childList(item).children)
    return 1 + Math.max(0, ...children.map((child) => this.height(child)))
  }

  parentItem(item) {
    const parent = item.parentElement.closest(ITEM)
    return parent && this.rootTarget.contains(parent) ? parent : null
  }

  childList(item) {
    return item.querySelector(":scope > ul.mw-menu-tree__children")
  }

  items() {
    return Array.from(this.rootTarget.querySelectorAll(ITEM))
  }

  changed() {
    this.dirty = true
    this.refresh()
  }

  refresh() {
    this.items().forEach((item) => {
      const depth = this.listDepth(item.parentElement)
      const above = item.previousElementSibling
      const indent = this.field(item, "indent")
      const outdent = this.field(item, "outdent")

      if (indent) indent.disabled = !above || !this.fits(item, this.childList(above))
      if (outdent) outdent.disabled = depth === 1
      this.field(item, "badge-too-deep").hidden = depth <= this.maxDepthValue
    })
    this.emptyTarget.hidden = this.rootTarget.children.length > 0
  }

  showLinkFields(item) {
    const type = this.linkType(item)
    item.querySelectorAll(":scope > .mw-menu-form [data-link-field]").forEach((field) => {
      field.hidden = field.dataset.linkField !== type
    })
  }

  updateSummary(item) {
    const type = this.linkType(item)
    const select = this.field(item, "page-select")
    const option = select.selectedOptions[0]
    const pageTitle = option?.value ? option.dataset.title : ""
    const url = this.field(item, "url-input").value.trim()
    const label = this.field(item, "label-input")

    label.placeholder = pageTitle
    this.field(item, "label").textContent = label.value.trim() || (type === "page" ? pageTitle : "") || "New item"

    const showsPage = type === "page" && Boolean(pageTitle)
    const showsUrl = type === "url" && Boolean(url)
    const none = this.field(item, "target-none")

    this.field(item, "page-title").textContent = pageTitle
    this.field(item, "url-text").textContent = url
    this.field(item, "external").hidden = !EXTERNAL_URL.test(url)
    this.field(item, "target-page").hidden = !showsPage
    this.field(item, "target-url").hidden = !showsUrl
    none.hidden = showsPage || showsUrl
    none.textContent = "Not linked yet"
    this.field(item, "badge-hidden").hidden = type !== "page" || !option?.value || option.dataset.published === "true"
  }

  linkType(item) {
    return item.querySelector(":scope > .mw-menu-form [data-role='link-type']:checked")?.value || "page"
  }

  field(item, role) {
    const selector = `[data-role='${role}']`
    return item.querySelector(`:scope > ${selector}, :scope > .mw-menu-row ${selector}, :scope > .mw-menu-form ${selector}`)
  }

  itemFor(event) {
    return event.currentTarget.closest(ITEM)
  }

  persisted(item) {
    return !item.dataset.key.startsWith("-")
  }

  refocus(item, role) {
    const button = this.field(item, role)
    if (button && !button.disabled) {
      button.focus()
    } else {
      this.field(item, "toggle").focus()
    }
  }
}
