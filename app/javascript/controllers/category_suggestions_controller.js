import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden"]

  select() {
    const value = this.inputTarget.value

    const option = this.categories.find(
      category => category.name === value
    )

    if (option) {
      this.hiddenTarget.value = option.id
    }
  }

  connect() {
    this.categories = JSON.parse(
      this.element.dataset.categories
    )
  }
}
