import { Controller } from "@hotwired/stimulus"

// 編集画面で参考画像を選ぶと、保存前でも「現在の参考画像」欄の末尾に
// 保存済み画像と同じ見た目でプレビュー表示する。
// プレビューの × を押すと、そのファイルは送信対象から外れる。
export default class extends Controller {
  static targets = ["input", "gallery"]

  connect() {
    this.dataTransfer = new DataTransfer()
    this.objectURLs = []
  }

  disconnect() {
    this.objectURLs.forEach((url) => URL.revokeObjectURL(url))
  }

  update() {
    for (const file of this.inputTarget.files) {
      if (file.type.startsWith("image/")) this.dataTransfer.items.add(file)
    }
    this.inputTarget.files = this.dataTransfer.files
    this.render()
  }

  remove(event) {
    const index = Number(event.currentTarget.dataset.index)
    const kept = new DataTransfer()
    Array.from(this.dataTransfer.files).forEach((file, i) => {
      if (i !== index) kept.items.add(file)
    })
    this.dataTransfer = kept
    this.inputTarget.files = this.dataTransfer.files
    this.render()
  }

  render() {
    this.objectURLs.forEach((url) => URL.revokeObjectURL(url))
    this.objectURLs = []
    this.galleryTarget.querySelectorAll("[data-preview]").forEach((el) => el.remove())

    Array.from(this.dataTransfer.files).forEach((file, i) => {
      const url = URL.createObjectURL(file)
      this.objectURLs.push(url)

      const item = document.createElement("div")
      item.className = "sub-image-item"
      item.dataset.preview = "true"

      const img = document.createElement("img")
      img.src = url
      img.className = "place-gallery-img"
      img.alt = ""

      const wrap = document.createElement("div")
      wrap.className = "sub-image-delete"

      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "sub-image-delete-btn"
      btn.textContent = "×"
      btn.dataset.index = i
      btn.dataset.action = "image-preview#remove"
      btn.setAttribute("aria-label", "この画像の選択を取り消す")

      wrap.appendChild(btn)
      item.appendChild(img)
      item.appendChild(wrap)
      this.galleryTarget.appendChild(item)
    })
  }
}