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
      )?.value || this.selectedOptionId

    this.finalTarget.innerHTML = ""

    let newOptionIndex = 0

    this.inputTargets
      .filter(input => !input.closest("#option-template"))
      .forEach((input, index) => {
        const optionItem =
          input.closest(".option-item")

        if (!optionItem) return

        // 削除された選択肢は最終決断にも表示しない
        const destroyFlag =
          optionItem.querySelector(".destroy-flag")

        if (
          destroyFlag?.value === "1" ||
          optionItem.style.display === "none"
        ) {
          return
        }

        // DBに保存済みの選択肢ならDBのIDを使う
        const idInput =
          optionItem.querySelector(
            "input[type='hidden'][name*='[id]']"
          )

        let optionId = idInput?.value

        // 新規選択肢なら仮IDを付ける
        if (!optionId) {
          optionId = `new_${newOptionIndex}`
          newOptionIndex++
        }

        const value =
          input.value.trim() ||
          `選択肢${index + 1}`

        const wrapper =
          document.createElement("div")

        wrapper.className = "form-check mb-2"

        const radio =
          document.createElement("input")

        radio.type = "radio"
        radio.name = "decision[selected_option_temp]"
        radio.value = optionId
        radio.dataset.optionId = optionId
        radio.className = "form-check-input"
        radio.id = `option_${index}`

        if (
          String(currentChecked) === String(optionId)
        ) {
          radio.checked = true
        }

        const label =
          document.createElement("label")

        label.className = "form-check-label"
        label.htmlFor = radio.id
        label.textContent = value

        wrapper.appendChild(radio)
        wrapper.appendChild(label)

        this.finalTarget.appendChild(wrapper)

        radio.addEventListener("change", () => {
          this.selectedOptionId = radio.value
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

    this.selectedOptionId = checked.value

    const label =
      checked.closest(".form-check")
        ?.querySelector("label")

    this.previewTarget.textContent =
      label?.textContent || "未選択"
  }
}
