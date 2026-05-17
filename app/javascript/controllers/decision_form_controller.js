import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    this.previewController =
      this.application.getControllerForElementAndIdentifier(
        document.querySelector("[data-controller~='decision-preview']"),
        "decision-preview"
      )
  }

  addOption() {
    const id = Date.now()

    const html = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      id
    )

    this.containerTarget.insertAdjacentHTML(
      "beforeend",
      html
    )

    this.previewController?.refresh()
  }

removeOption(event) {
  const item =
    event.currentTarget.closest(".option-item")

  if (!item) return

  const destroy =
    item.querySelector(".destroy-flag")

  if (destroy) {
    destroy.value = "1"
    item.style.display = "none"
  } else {
    item.remove()
  }

  const previewController =
    this.application.getControllerForElementAndIdentifier(
      document.querySelector(
        "[data-controller*='decision-preview']"
      ),
      "decision-preview"
    )

  previewController?.refresh()
}
}
