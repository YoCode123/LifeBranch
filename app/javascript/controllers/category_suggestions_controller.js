import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list", "hidden"]

  connect() {
    document.addEventListener("click", this.close.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.close.bind(this))
  }

  search() {
    const keyword = this.inputTarget.value

    fetch(`/categories/search?keyword=${encodeURIComponent(keyword)}`)
      .then(response => response.json())
      .then(categories => {
        this.listTarget.innerHTML = ""

        categories.forEach(category => {
          const button = document.createElement("button")

          button.type = "button"
          button.className =
            "list-group-item list-group-item-action"

          button.textContent = category.name

          button.addEventListener("click", (event) => {
            event.stopPropagation()

            this.inputTarget.value = category.name
            this.hiddenTarget.value = category.id
            this.listTarget.innerHTML = ""
          })

          this.listTarget.appendChild(button)
        })
      })
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.listTarget.innerHTML = ""
    }
  }
}
