// Handles closing the shared Turbo frame modal via backdrop clicks, close buttons, and Escape.
// Usage: data-controller="modal" on the modal wrapper rendered inside #modal_content.
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

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

  submitEnd(event) {
    if (!event.detail.success) return

    const response = event.detail.fetchResponse?.response
    if (!response?.redirected) return

    const url = response.url
    this.clearModal()
    Turbo.visit(url)
  }

  onKeydown(event) {
    if (event.key === "Escape") {
      this.clearModal()
    }
  }
}
