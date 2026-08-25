import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    this.previewController =
      this.application.getControllerForElementAndIdentifier(
        this.element,
        "decision-preview"
      )
  }

  addOption() {
    const id = Date.now()

    const html =
      this.templateTarget.innerHTML.replace(
        /NEW_RECORD/g,
        id
      )

    this.containerTarget.insertAdjacentHTML(
      "beforeend",
      html
    )

    const items =
      this.containerTarget.querySelectorAll(
        ".option-item"
      )

    const newItem =
      items[items.length - 1]

    if (newItem) {
      newItem.dataset.optionId = `new_${id}`
    }

    this.previewController?.refresh()
  }

  removeOption(event) {
    const item =
      event.currentTarget.closest(".option-item")

    if (!item) return

    const visibleItems =
      Array.from(
        this.containerTarget.querySelectorAll(
          ".option-item"
        )
      ).filter(item => {
        const destroyFlag =
          item.querySelector(".destroy-flag")

        return (
          item.style.display !== "none" &&
          destroyFlag?.value !== "1"
        )
      })

    // 選択肢は最低1つ残す
    if (visibleItems.length <= 1) {
      alert("選択肢は最低1つ必要です")
      return
    }

    // 削除する選択肢のID
    const idInput =
      item.querySelector(
        "input[name*='[id]']"
      )

    const optionId =
      idInput?.value ||
      item.dataset.optionId

    // 最終決断の対象
    const finalTarget =
      document.querySelector(
        "[data-decision-preview-target='final']"
      )

    if (finalTarget && optionId) {
      const radio =
        finalTarget.querySelector(
          `input[data-option-id="${optionId}"]`
        )

      // 最終決断から直接削除
      if (radio) {
        const wrapper =
          radio.closest(".form-check")

        if (wrapper) {
          wrapper.remove()
        } else {
          radio.remove()
        }
      }

      // 削除した選択肢が現在の最終決断だった場合
      if (
        finalTarget.dataset.selectedOptionId ===
        String(optionId)
      ) {
        finalTarget.dataset.selectedOptionId = ""

        if (this.previewController) {
          this.previewController.selectedOptionId = ""
        }

        const preview =
          document.querySelector(
            "[data-decision-preview-target='preview']"
          )

        if (preview) {
          preview.textContent = "未選択"
        }
      }
    }

    // DBに保存済みの選択肢
    const destroyFlag =
      item.querySelector(".destroy-flag")

    if (destroyFlag) {
      destroyFlag.value = "1"
      item.style.display = "none"
    } else {
      // 新規追加した選択肢
      item.remove()
    }

    // 最終決断を再構築
    this.previewController?.refresh()
  }
}
