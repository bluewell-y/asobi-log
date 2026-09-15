import { Controller } from "@hotwired/stimulus"

// 複数選択できる「その他」タグのセレクトから選んだタグを、チップとして並べて表示する。
// チップの × を押すと、セレクト側の選択も解除され、保存前でもその場で取り消せる。
// <details>で開閉する場合は、OKボタンを押すと選択を確定して閉じる。
export default class extends Controller {
  static targets = ["select", "chips", "hiddenFields", "summaryText", "details"]
  static values = { tagNames: Object, fieldName: String }

  connect() {
    this.render()
  }

  sync() {
    this.render()
  }
  
  apply() {
    this.render()
    if (this.hasDetailsTarget) this.detailsTarget.open = false
  }

  remove(event) {
    const id = event.currentTarget.dataset.id
    const option = this.selectTarget.querySelector(`option[value="${id}"]`)
    if (option) option.selected = false
    this.render()
  }

  render() {
    if (this.hasSummaryTextTarget) {
      const count = this.selectTarget.selectedOptions.length
      this.summaryTextTarget.textContent = count > 0 ? `${count}件選択中` : "選択してください"
    }

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
      hidden.name = this.fieldNameValue
      hidden.value = id
      this.hiddenFieldsTarget.appendChild(hidden)
    })
  }
}