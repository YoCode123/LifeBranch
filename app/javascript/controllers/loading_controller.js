import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    const button = this.element.querySelector("input[type='submit']")

    if (!button) return

    button.disabled = true
    button.value = button.dataset.loadingText || "処理中..."
  }
}
