import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["column"]

  connect() {
    this.columnTargets.forEach(column => {
      new Sortable(column, {
        group: "issues",
        animation: 150,
        ghostClass: "kanban-card--ghost",
        dragClass: "kanban-card--drag",
        draggable: ".kanban-card",
        filter: ".kanban-add-card",
        onEnd: (event) => this.onEnd(event)
      })
    })
  }

  onEnd(event) {
    const issueId = event.item.dataset.issueId
    const boardStateId = event.to.dataset.boardStateId

    // Suppress the click-after-drag on the link inside the card
    if (event.from !== event.to || event.oldIndex !== event.newIndex) {
      const link = event.item.querySelector("a")
      if (link) {
        const suppress = (e) => { e.preventDefault(); e.stopPropagation(); link.removeEventListener("click", suppress) }
        link.addEventListener("click", suppress, { once: true })
      }
    }

    if (event.from !== event.to) {
      const countFrom = event.from.closest(".kanban-column").querySelector(".kanban-count")
      const countTo = event.to.closest(".kanban-column").querySelector(".kanban-count")
      countFrom.textContent = parseInt(countFrom.textContent) - 1
      countTo.textContent = parseInt(countTo.textContent) + 1
    }

    if (event.from !== event.to) {
      fetch(`/issues/${issueId}/move`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ board_state_id: boardStateId })
      })
    }
  }
}
