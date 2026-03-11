import SortableListController from "dash_kit/sortable_list_controller"

export function registerControllers(application) {
  application.register("sortable-list", SortableListController)
}

export { SortableListController }
