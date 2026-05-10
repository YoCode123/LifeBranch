import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "radio",
    "label",
    "preview"
  ]

  connect() {
    this.updateLabels()
    this.updatePreview()
  }

  updateLabels() {
    this.inputTargets.forEach((input, index) => {
      const label = this.labelTargets[index]

      if (!label) return

      label.textContent =
        input.value.trim() || `選択肢${index + 1}`
    })
  }

  updatePreview() {
    const checkedRadio =
      this.radioTargets.find(radio => radio.checked)

    if (!checkedRadio) {
      this.previewTarget.textContent = "未選択"
      return
    }

    const index = checkedRadio.value
    const input = this.inputTargets[index]

    this.previewTarget.textContent =
      input.value.trim() || `選択肢${Number(index) + 1}`
  }

  refresh() {
    this.updateLabels()
    this.updatePreview()
  }
}
