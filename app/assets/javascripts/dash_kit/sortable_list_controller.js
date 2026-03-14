import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Handles dashboard widget visibility toggles and reordering.
// Changes are batched and saved when the modal closes (done action).
export default class extends Controller {
  static targets = ["list"]
  static values = {
    reorderUrl: String
  }

  connect() {
    this.dirty = false

    if (this.hasListTarget) {
      this.sortable = Sortable.create(this.listTarget, {
        handle: "[data-sortable-handle]",
        animation: 150,
        onEnd: () => { this.dirty = true }
      })
    }
  }

  disconnect() {
    this.sortable?.destroy()
  }

  toggle(event) {
    this.dirty = true
    const row = event.target.closest("[data-widget-key]")
    const isVisible = row.dataset.visible === "true"
    row.dataset.visible = String(!isVisible)

    // Toggle visual state
    const btn = row.querySelector("button[data-action='sortable-list#toggle']")
    if (isVisible) {
      row.classList.remove("bg-white", "dark:bg-zinc-800")
      row.classList.add("bg-gray-50", "dark:bg-zinc-900", "opacity-60")
      btn.classList.remove("bg-accent-600", "border-accent-600")
      btn.classList.add("border-gray-300", "dark:border-zinc-600")
      btn.innerHTML = ""
    } else {
      row.classList.remove("bg-gray-50", "dark:bg-zinc-900", "opacity-60")
      row.classList.add("bg-white", "dark:bg-zinc-800")
      btn.classList.remove("border-gray-300", "dark:border-zinc-600")
      btn.classList.add("bg-accent-600", "border-accent-600")
      btn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="size-3 text-white"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" /></svg>'
    }
  }

  markDirty() {
    this.dirty = true
  }

  async done() {
    if (this.dirty && this.hasListTarget && this.hasReorderUrlValue) {
      const items = this.listTarget.querySelectorAll("[data-widget-key]")
      const widgetOrder = []
      const hiddenWidgets = []

      items.forEach(el => {
        widgetOrder.push(el.dataset.widgetKey)
        if (el.dataset.visible === "false") {
          hiddenWidgets.push(el.dataset.widgetKey)
        }
      })

      const csrfToken = document.querySelector("meta[name='csrf-token']")?.content

      await fetch(this.reorderUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ widget_order: widgetOrder, hidden_widgets: hiddenWidgets })
      })
    }

    if (this.dirty) {
      window.Turbo.visit(window.location.href, { action: "replace" })
    }
  }
}
