import { Controller } from "@hotwired/stimulus"

// Handles dashboard widget reordering and tracks dirty state.
// When changes are made (toggle or reorder), refreshes the page on modal close.
export default class extends Controller {
  static targets = ["list"]
  static values = {
    reorderUrl: String
  }

  connect() {
    this.dirty = false
  }

  markDirty() {
    this.dirty = true
  }

  async done() {
    if (this.dirty && this.hasListTarget && this.hasReorderUrlValue) {
      const items = this.listTarget.querySelectorAll("[data-widget-key]")
      const widgetOrder = Array.from(items).map(el => el.dataset.widgetKey)

      const csrfToken = document.querySelector("meta[name='csrf-token']")?.content

      await fetch(this.reorderUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ widget_order: widgetOrder })
      })
    }

    if (this.dirty) {
      window.Turbo.visit(window.location.href, { action: "replace" })
    }
  }
}
