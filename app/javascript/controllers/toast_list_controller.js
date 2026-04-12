// Stacks toasts inside a position container so newer ones stay closest to the edge.
// Usage: data-controller="toast-list" on each toast container.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = {
    gutter: { type: Number, default: 12 },
    position: { type: String, default: "top-center" }
  }

  initialize() {
    this.onToastExiting = this.onToastExiting.bind(this)
    this.pendingLayout = false
  }

  connect() {
    this.element.addEventListener("toast:exiting", this.onToastExiting)
    this.requestLayout({ defer: true })
  }

  disconnect() {
    this.element.removeEventListener("toast:exiting", this.onToastExiting)
  }

  toastTargetConnected() {
    this.requestLayout({ defer: true })
  }

  toastTargetDisconnected() {
    this.requestLayout()
  }

  onToastExiting(event) {
    const toast = event.target.closest('[data-toast-list-target="toast"]')
    if (!toast) return

    toast.dataset.exiting = "true"
    this.requestLayout()
  }

  requestLayout({ defer = false } = {}) {
    if (this.pendingLayout) return

    this.pendingLayout = true
    const relayout = () => {
      this.pendingLayout = false
      if (!this.element.isConnected) return
      this.layoutToasts()
    }

    if (defer) {
      requestAnimationFrame(() => requestAnimationFrame(relayout))
    } else {
      requestAnimationFrame(relayout)
    }
  }

  layoutToasts() {
    let offset = 0
    const multiplier = this.positionValue.startsWith("top") ? 1 : -1

    for (let index = this.toastTargets.length - 1; index >= 0; index -= 1) {
      const toast = this.toastTargets[index]
      toast.style.transform = `translate3d(0, ${multiplier * offset}px, 0)`

      if (toast.dataset.exiting !== "true") {
        offset += toast.offsetHeight + this.gutterValue
      }
    }
  }
}
