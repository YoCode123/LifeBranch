// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const inputs = document.querySelectorAll(".option-input");
  const radios = document.querySelectorAll(".decision-radio");
  const preview = document.getElementById("selected-option-preview");

  inputs.forEach((input) => {
    input.addEventListener("input", (e) => {
      const index = e.target.dataset.index;
      const label = document.getElementById(`option-label-${index}`);
      if (label) {
        label.textContent = e.target.value || `選択肢${parseInt(index) + 1}`;
      }
    });
  });

  radios.forEach((radio) => {
    radio.addEventListener("change", (e) => {
      const parent = e.target.closest(".decision-option");
      const label = parent?.querySelector(".decision-label");

      if (label && preview) {
        preview.textContent = `${label.textContent} を選択中`;
      }
    });
  });
});

document.addEventListener("turbo:load", () => {
  const addBtn = document.getElementById("add-option-btn");
  const container = document.getElementById("options-container");
  const template = document.getElementById("option-template");

  if (!addBtn || !container || !template) return;

  let index = container.querySelectorAll(".option-item").length;

  addBtn.addEventListener("click", () => {
    let newOption = template.innerHTML.replace(/NEW_RECORD/g, index);
    container.insertAdjacentHTML("beforeend", newOption);
    index++;
  });
});

document.addEventListener("turbo:load", () => {
  document.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-option-btn")) {
      const item = e.target.closest(".option-item");
      const destroyInput = item.querySelector(".destroy-flag");

      if (destroyInput) {
        destroyInput.value = "1";
        item.style.display = "none";
      } else {
        item.remove();
      }
    }
  });
});


