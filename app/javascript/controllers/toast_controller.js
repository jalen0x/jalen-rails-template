// Controls a single toast's dismissal lifecycle.
// Usage: data-controller="toast" on the toast wrapper.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = {
    dismissAfter: { type: Number, default: 0 },
    removeDelay: { type: Number, default: 220 }
  }

  connect() {
    this.closing = false
    this.resetAutoDismiss()
  }

  disconnect() {
    this.clearTimers()
  }

  close(event) {
    event?.preventDefault()
    if (this.closing) return

    this.closing = true
    this.clearTimers()
    this.element.dataset.exiting = "true"
    this.contentTarget.classList.add("opacity-0", "scale-95")
    this.dispatch("exiting", { bubbles: true })

    this.removeTimer = setTimeout(() => {
      this.element.remove()
    }, this.removeDelayValue)
  }

  dismissAfterValueChanged() {
    this.resetAutoDismiss()
  }

  resetAutoDismiss() {
    clearTimeout(this.autoDismissTimer)
    this.autoDismissTimer = null
    if (this.closing || this.dismissAfterValue <= 0) return

    this.autoDismissTimer = setTimeout(() => this.close(), this.dismissAfterValue)
  }

  clearTimers() {
    clearTimeout(this.autoDismissTimer)
    clearTimeout(this.removeTimer)
    this.autoDismissTimer = null
    this.removeTimer = null
  }
}
