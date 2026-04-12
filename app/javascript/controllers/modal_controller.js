// Handles closing the shared Turbo frame modal via backdrop clicks, close buttons, and Escape.
// Usage: data-controller="modal" on the modal wrapper rendered inside #modal_content.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.onKeydown = this.onKeydown.bind(this)
    document.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  backdropClose(event) {
    if (event.target !== this.element) return
    this.clearModal()
  }

  close(event) {
    event.preventDefault()
    this.clearModal()
  }

  clearModal() {
    this.element.closest("turbo-frame")?.replaceChildren()
  }

  onKeydown(event) {
    if (event.key === "Escape") {
      this.clearModal()
    }
  }
}
