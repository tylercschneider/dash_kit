import { describe, it, expect, beforeEach, afterEach } from "vitest"
import { Application } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import SortableListController from "../../app/assets/javascripts/dash_kit/sortable_list_controller.js"

function nextTick() {
  return new Promise(resolve => setTimeout(resolve, 0))
}

describe("SortableListController", () => {
  let application

  beforeEach(() => {
    application = Application.start()
    application.register("sortable-list", SortableListController)
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  function mountController() {
    document.body.innerHTML = `
      <div data-controller="sortable-list" data-sortable-list-reorder-url-value="/dash_kit/configurations/1/reorder">
        <div data-sortable-list-target="list">
          <div data-widget-key="widget_a" data-visible="true">
            <div data-sortable-handle>handle</div>
          </div>
          <div data-widget-key="widget_b" data-visible="true">
            <div data-sortable-handle>handle</div>
          </div>
        </div>
      </div>
    `
    return nextTick()
  }

  it("initializes SortableJS on the list target", async () => {
    await mountController()
    const list = document.querySelector("[data-sortable-list-target='list']")
    expect(Sortable.get(list)).toBeTruthy()
  })
})
