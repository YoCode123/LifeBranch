// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const inputs = document.querySelectorAll(".option-input");

  inputs.forEach((input) => {
    input.addEventListener("input", (e) => {
      const index = e.target.dataset.index;
      const label = document.getElementById(`option-label-${index}`);

      if (label) {
        label.textContent = e.target.value || `選択肢${parseInt(index) + 1}`;
      }
    });
  });
});



