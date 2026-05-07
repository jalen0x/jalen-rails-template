import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backup", "digit", "digits", "input", "hidden"]
  static values = { allowBackupCode: Boolean, autoSubmit: Boolean }

  connect() {
    this.updateDisplay("")
    setTimeout(() => this.inputTarget.focus(), 100)
  }

  focus(event) {
    event.preventDefault()
    this.inputTarget.focus()
  }

  handleFocus(event) {
    this.updateDisplay(event.target.value)
  }

  handleBlur() {
    this.digitTargets.forEach((digit) => digit.classList.remove("second-factor-code-active"))
  }

  handleInput(event) {
    const value = this.normalize(event.target.value)
    event.target.value = value
    this.hiddenTarget.value = value
    this.updateDisplay(value)
    this.submitIfComplete(value)
  }

  handlePaste(event) {
    event.preventDefault()

    const value = this.normalize(event.clipboardData?.getData("text/plain") || "")
    if (!value) return

    this.inputTarget.value = value
    this.hiddenTarget.value = value
    this.updateDisplay(value)
    this.submitIfComplete(value)
  }

  normalize(value) {
    if (this.allowBackupCodeValue) {
      const compactValue = value.replace(/[\s-]/g, "")
      if (/[A-Za-z]/.test(compactValue) || compactValue.length > 6) return compactValue.slice(0, 64)
    }

    return value.replace(/\D/g, "").slice(0, 6)
  }

  updateDisplay(value) {
    const displayingBackupCode = this.allowBackupCodeValue && (/[A-Za-z]/.test(value) || value.length > 6)

    if (this.hasDigitsTarget) this.digitsTarget.classList.toggle("hidden", displayingBackupCode)
    if (this.hasBackupTarget) {
      this.backupTarget.textContent = value
      this.backupTarget.classList.toggle("hidden", !displayingBackupCode)
      this.backupTarget.classList.toggle("flex", displayingBackupCode)
    }

    this.digitTargets.forEach((digit, index) => {
      digit.textContent = value[index] || ""
      digit.classList.toggle("second-factor-code-active", !displayingBackupCode && index === value.length && value.length < 6)
    })
  }

  submitIfComplete(value) {
    if (!this.autoSubmitValue || this.submitted || !/^\d{6}$/.test(value)) return

    this.submitted = true
    this.element.closest("form")?.requestSubmit()
  }
}
