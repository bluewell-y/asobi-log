import { Controller } from "@hotwired/stimulus"                       

// 画像をクリック／タップすると、全体像を拡大表示する
export default class extends Controller {
  static targets = ["dialog", "image"]
                                                                      
  open(event) {                                                                                          
    this.imageTarget.src = event.currentTarget.dataset.lightboxFull
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()                                         
  }                                                                                                      
}