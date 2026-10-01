import { Controller } from "@hotwired/stimulus"

// 編集画面で参考画像を選ぶと、保存前でも「現在の参考画像」欄の末尾に
// 保存済み画像と同じ見た目でプレビュー表示する。
// プレビューの × を押すと、そのファイルは送信対象から外れる。
// トップ画像は1枚だけなので、選んだ画像をそのままプレビュー表示する。
export default class extends Controller {
  static targets = ["input", "gallery", "coverInput", "coverPreview"]

  connect() {
    this.dataTransfer = new DataTransfer()
    this.objectURLs = []
    this.coverObjectURL = null
    this.element.addEventListener("turbo:submit-end", this.scrollToErrorsIfNeeded)
  }

  disconnect() {
    this.objectURLs.forEach((url) => URL.revokeObjectURL(url))
    if (this.coverObjectURL) URL.revokeObjectURL(this.coverObjectURL)
    this.element.removeEventListener("turbo:submit-end", this.scrollToErrorsIfNeeded)
  }

  scrollToErrorsIfNeeded = (event) => {
    if (event.detail.success) return
    const errors = document.getElementById("place-form-errors")
    if (errors) errors.scrollIntoView({ behavior: "smooth", block: "start" })
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

  updateCover() {
    const file = this.coverInputTarget.files[0]
    if (this.coverObjectURL) URL.revokeObjectURL(this.coverObjectURL)
    this.coverPreviewTarget.innerHTML = ""

    if (file && file.type.startsWith("image/")) {
      this.coverObjectURL = URL.createObjectURL(file)

      const item = document.createElement("div")
      item.className = "sub-image-item"

      const img = document.createElement("img")
      img.src = this.coverObjectURL
      img.className = "place-gallery-img"
      img.alt = ""

      const wrap = document.createElement("div")
      wrap.className = "sub-image-delete"

      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "sub-image-delete-btn"
      btn.textContent = "×"
      btn.dataset.action = "image-preview#clearCover"
      btn.setAttribute("aria-label", "トップ画像の選択を取り消す")

      wrap.appendChild(btn)
      item.appendChild(img)
      item.appendChild(wrap)
      this.coverPreviewTarget.appendChild(item)
    }
  }

  clearCover() {
    this.coverInputTarget.value = ""
    this.updateCover()
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