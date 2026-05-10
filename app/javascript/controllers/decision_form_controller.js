import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "final"]

  connect() {
    this.refresh()
  }

  addOption() {
    const html = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      Date.now()
    )

    this.containerTarget.insertAdjacentHTML(
      "beforeend",
      html
    )

    this.refresh()
  }

  removeOption(event) {
    const item =
      event.currentTarget.closest(".option-item")

    if (!item) return

    const allItems = [
      ...this.containerTarget.querySelectorAll(".option-item")
    ]

    const index = allItems.indexOf(item)

    const radios =
      this.finalTarget.querySelectorAll(
        ".decision-radio"
      )

    const targetRadio = radios[index]

    if (targetRadio?.checked) {
      targetRadio.checked = false
    }

    const destroy =
      item.querySelector(".destroy-flag")

    if (destroy) {
      destroy.value = "1"
      item.style.display = "none"
    } else {
      item.remove()
    }

    this.refresh()
  }

  refresh() {
    const inputs = [
      ...this.containerTarget.querySelectorAll(
        ".option-input"
      )
    ].filter((input) => {
      return (
        input.closest(".option-item").style.display !==
        "none"
      )
    })

    const currentChecked =
      this.finalTarget.querySelector(
        ".decision-radio:checked"
      )

    const checkedValue =
      currentChecked?.value

    this.finalTarget.innerHTML = ""

    inputs.forEach((input, index) => {
      const value =
        input.value || `選択肢${index + 1}`

      const checked =
        checkedValue == index ? "checked" : ""

      const html = `
        <div class="form-check mb-2">

          <input
            type="radio"
            name="decision[selected_option_index]"
            value="${index}"
            id="option_${index}"
            class="form-check-input decision-radio"
            data-action="change->decision-form#refresh"
            ${checked}>

          <label
            for="option_${index}"
            class="form-check-label">
            ${value}
          </label>

        </div>
      `

      this.finalTarget.insertAdjacentHTML(
        "beforeend",
        html
      )
    })

    const checked =
      this.finalTarget.querySelector(
        ".decision-radio:checked"
      )

    const preview =
      document.getElementById(
        "selected-option-preview"
      )

    if (!preview) return

    if (!checked) {
      preview.textContent = "未選択"
      return
    }

    const targetInput =
      inputs[Number(checked.value)]

    preview.textContent =
      targetInput?.value || "未選択"
  }
}
