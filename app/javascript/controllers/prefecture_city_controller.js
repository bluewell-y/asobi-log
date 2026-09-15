import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prefecture", "city"]
  static values = { cities: Object, blankLabel: String }

  connect() {
    this.updateCities()
  }                                                                       

  updateCities() {
    const selectedCity = this.cityTarget.dataset.selected                 
    const prefecture = this.prefectureTarget.value
    const cities = this.citiesValue[prefecture] || []

    this.cityTarget.innerHTML = ""
    const blank = document.createElement("option")
    blank.value = ""
    blank.textContent = this.hasBlankLabelValue ? this.blankLabelValue : "選択してください"
    this.cityTarget.appendChild(blank)

    cities.forEach((city) => {
      const option = document.createElement("option")
      option.value = city
      option.textContent = city
      if (city === selectedCity) option.selected = true
      this.cityTarget.appendChild(option)
    })
  }
}