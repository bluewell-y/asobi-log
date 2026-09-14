import { Controller } from "@hotwired/stimulus"

// 複数選択できる「その他」タグのセレクトから選んだタグを、チップとして並べて表示する。
// チップの × を押すと、セレクト側の選択も解除され、保存前でもその場で取り消せる。
export default class extends Controller {
  static targets = ["select", "chips", "hiddenFields"]
  static values = { tagNames: Object }

  connect() {
    this.render()
  }

  sync() {
    this.render()
  }

  remove(event) {
    const id = event.currentTarget.dataset.id
    const option = this.selectTarget.querySelector(`option[value="${id}"]`)
    if (option) option.selected = false
    this.render()
  }

  render() {
    this.chipsTarget.innerHTML = ""
    this.hiddenFieldsTarget.innerHTML = ""

    Array.from(this.selectTarget.selectedOptions).forEach((option) => {
      const id = option.value

      const chip = document.createElement("span")
      chip.className = "tag-chip"

      const label = document.createElement("span")
      label.textContent = this.tagNamesValue[id]

      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "tag-chip-remove"
      btn.textContent = "×"
      btn.dataset.id = id
      btn.dataset.action = "tag-picker#remove"
      btn.setAttribute("aria-label", `${this.tagNamesValue[id]}を削除`)

      chip.appendChild(label)
      chip.appendChild(btn)
      this.chipsTarget.appendChild(chip)

      const hidden = document.createElement("input")
      hidden.type = "hidden"
      hidden.name = "place[tag_ids][]"
      hidden.value = id
      this.hiddenFieldsTarget.appendChild(hidden)
    })
  }
}