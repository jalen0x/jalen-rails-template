// Custom Flowbite Modal for confirm dialogs
//
// Example usage:
//
//   <%= button_to "Delete", my_path, method: :delete, form: {
//     data: {
//       turbo_confirm: "Are you sure?",
//       turbo_confirm_description: "This will delete your record. Enter the record name to confirm.",
//       turbo_confirm_text: "record name", # require the user to type this before confirming
//       turbo_confirm_accept: "Yes, delete it",
//       turbo_confirm_reject: "No, keep it",
//       turbo_confirm_variant: "brand" # "danger" (default) or "brand"
//     }
//   } %>

function datasetValue(button, element, key, fallback = "") {
  return button?.dataset?.[key] || element.dataset[key] || fallback
}

function confirmInputHtml(confirmText) {
  if (!confirmText) return ""

  return `
      <div class="mt-2 mb-4">
        <label class="block mb-2 text-sm font-medium text-heading">
          Please type "<span class="font-semibold">${confirmText}</span>" to confirm.
        </label>
        <input type="text" data-behavior="confirm-text"
               class="bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full px-3 py-2.5 shadow-xs placeholder:text-body"
               placeholder="${confirmText}">
      </div>
    `
}

function descriptionHtml(description) {
  return description
    ? `<p class="mb-4 font-light text-body-subtle">${description}</p>`
    : ""
}

function confirmButtonHtml(accept, variant) {
  if (variant === "brand") {
    return `
            <button type="button" data-action="confirm"
                    class="inline-flex items-center text-white bg-brand box-border border border-transparent hover:bg-brand-strong focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none">
              ${accept}
            </button>`
  }

  return `
            <button type="button" data-action="confirm"
                    class="inline-flex items-center text-white bg-danger box-border border border-transparent hover:bg-danger-strong focus:ring-4 focus:ring-danger-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none">
              <svg aria-hidden="true" class="w-4 h-4 mr-1.5 -ml-1" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path>
              </svg>
              ${accept}
            </button>`
}

function insertConfirmModal(message, element, button) {
  const confirmText = datasetValue(button, element, "turboConfirmText", null)
  const description = datasetValue(button, element, "turboConfirmDescription")
  const accept = datasetValue(button, element, "turboConfirmAccept", "Confirm")
  const reject = datasetValue(button, element, "turboConfirmReject", "Cancel")
  const variant = datasetValue(button, element, "turboConfirmVariant", "danger")

  const id = `confirm-modal-${Date.now()}`

  const content = `
    <div id="${id}" tabindex="-1" aria-hidden="true"
         class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-modal md:h-full">
      <div class="relative p-4 w-full max-w-md h-full md:p-0 md:h-auto">
        <div class="relative p-4 bg-neutral-primary-soft border border-default rounded-base shadow-sm sm:p-5">
          <!-- Close button -->
          <button type="button" data-action="close"
                  class="text-body absolute top-2.5 right-2.5 bg-transparent hover:bg-neutral-tertiary hover:text-heading rounded-base text-sm w-9 h-9 ms-auto inline-flex items-center justify-center">
            <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
            </svg>
            <span class="sr-only">Close modal</span>
          </button>

          <h3 class="mb-2 text-lg font-semibold text-heading">${message}</h3>
          ${descriptionHtml(description)}
          ${confirmInputHtml(confirmText)}

          <div class="flex items-center space-x-4">
            <button type="button" data-action="cancel"
                    class="text-body bg-neutral-secondary-medium box-border border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none">
              ${reject}
            </button>
            ${confirmButtonHtml(accept, variant)}
          </div>
        </div>
      </div>
    </div>
  `

  document.body.insertAdjacentHTML("beforeend", content)
  const modalElement = document.getElementById(id)

  if (confirmText) {
    const confirmButton = modalElement.querySelector('[data-action="confirm"]')
    confirmButton.disabled = true
    confirmButton.classList.add("opacity-50", "cursor-not-allowed")

    modalElement.querySelector('input[data-behavior="confirm-text"]').addEventListener("input", (event) => {
      const matches = event.target.value === confirmText
      confirmButton.disabled = !matches
      confirmButton.classList.toggle("opacity-50", !matches)
      confirmButton.classList.toggle("cursor-not-allowed", !matches)
    })
  }

  return modalElement
}

Turbo.config.forms.confirm = (message, element, button) => {
  const modalElement = insertConfirmModal(message, element, button)

  return new Promise((resolve) => {
    let confirmed = false

    const modal = new Modal(modalElement, {
      backdrop: "dynamic",
      closable: true,
      onHide: () => {
        resolve(confirmed)
        modal.destroyAndRemoveInstance()
        modalElement.remove()
      }
    })

    modalElement.querySelector('[data-action="confirm"]').addEventListener("click", () => {
      confirmed = true
      modal.hide()
    })

    modalElement.querySelector('[data-action="cancel"]').addEventListener("click", () => {
      modal.hide()
    })

    modalElement.querySelector('[data-action="close"]').addEventListener("click", () => {
      modal.hide()
    })

    modal.show()

    modalElement.querySelector('[data-action="cancel"]').focus()
  })
}
