import { Controller } from "@hotwired/stimulus"

// 画像クリックで全体像を拡大表示。矢印・スワイプ・←→キーで前後の画像に移動できる
export default class extends Controller {
  static targets = ["dialog", "image", "prevButton", "nextButton"]

  connect() {
    this.urls = Array.from(this.element.querySelectorAll("[data-lightbox-full]"))
      .map((el) => el.dataset.lightboxFull)
    this.index = 0
  }

  open(event) {
    const url = event.currentTarget.dataset.lightboxFull
    this.index = Math.max(0, this.urls.indexOf(url))
    this.render()
    this.dialogTarget.showModal()
  }

  dismiss() {
    this.dialogTarget.close()
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) this.dialogTarget.close()
  }

  next() {
    this.index = (this.index + 1) % this.urls.length
    this.render()
  }

  prev() {
    this.index = (this.index - 1 + this.urls.length) % this.urls.length
    this.render()
  }

  keydown(event) {
    if (!this.dialogTarget.open) return
    if (event.key === "ArrowRight") this.next()
    else if (event.key === "ArrowLeft") this.prev()
  }

  touchStart(event) {
    this.touchStartX = event.changedTouches[0].clientX
  }

  touchEnd(event) {
    if (this.touchStartX == null) return
    const dx = event.changedTouches[0].clientX - this.touchStartX
    if (Math.abs(dx) > 40) dx < 0 ? this.next() : this.prev()
    this.touchStartX = null
  }

  render() {
    this.imageTarget.src = this.urls[this.index]
    const multiple = this.urls.length > 1
    this.prevButtonTarget.hidden = !multiple
    this.nextButtonTarget.hidden = !multiple
  }
}