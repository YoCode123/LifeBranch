import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "final", "preview"]

  connect() {
    this.selectedOptionId =
      this.finalTarget.dataset.selectedOptionId || ""

    this.refresh()
  }

  refresh() {
    this.renderFinal()
    this.updatePreview()
  }

  renderFinal() {
    const currentChecked =
      this.finalTarget.querySelector(
        "input[type='radio']:checked"
      )?.dataset.optionId || this.selectedOptionId

    this.finalTarget.innerHTML = ""

    this.inputTargets
      .filter(input => !input.closest("#option-template"))
      .forEach((input, index) => {

        const optionItem =
          input.closest(".option-item")

        if (
          !optionItem ||
          optionItem.style.display === "none"
        ) {
          return
        }

        const optionIdInput =
          optionItem.querySelector(
            "input[name*='[id]']"
          )

        const savedOptionId =
          optionIdInput?.value

        const optionId =
          savedOptionId || `new_${index}`



        const value =
          input.value.trim() || `選択肢${index + 1}`

        const checked =
          String(currentChecked) === String(optionId)

        const wrapper =
          document.createElement("div")

        wrapper.className = "form-check mb-2"

        wrapper.innerHTML = `
          <input
            type="radio"
            name="decision[selected_option_temp]"
            value="${optionId}"
            data-option-id="${optionId}"
            class="form-check-input"
            id="option_${index}"
            ${checked ? "checked" : ""}
          >

          <label
            class="form-check-label"
            for="option_${index}">
            ${value}
          </label>
        `

        this.finalTarget.appendChild(wrapper)
      })

    this.finalTarget
      .querySelectorAll("input[type='radio']")
      .forEach(radio => {
        radio.addEventListener("change", () => {
          this.updatePreview()
        })
      })
  }

  updatePreview() {
    const checked =
      this.finalTarget.querySelector(
        "input[type='radio']:checked"
      )

    if (!checked) {
      this.previewTarget.textContent = "未選択"
      return
    }

    this.selectedOptionId =
      checked.dataset.optionId

    const label =
      checked.closest(".form-check")
        ?.querySelector("label")

    this.previewTarget.textContent =
      label?.textContent || "未選択"
  }
}
