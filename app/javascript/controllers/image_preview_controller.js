import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  previewImage() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()

    reader.onload = (event) => {
      this.previewTarget.src = event.target.result
    }

    reader.readAsDataURL(file)
  }
}
