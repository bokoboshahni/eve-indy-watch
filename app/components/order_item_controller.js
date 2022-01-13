import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'autocomplete', 'item', 'icon', 'name', 'category', 'group', 'type', 'subtotal', 'price', 'quantity', 'subtotalField',
    'buyPrice', 'sellPrice', 'splitPrice'
  ]

  connect() {
    document.addEventListener('autocomplete.change', this.autocomplete.bind(this))
  }

  autocomplete(event) {
    this.autocompleteTarget.classList.add('hidden')

    const url = "/orders/item?type_id=" + this.typeTarget.value
    fetch(url)
      .then(response => response.json())
      .then(data => {
        const appraisalSellPrice = data.appraisal_sell_price || 0.0

        this.iconTarget.src = data.icon_url
        this.nameTarget.innerHTML = data.name
        this.categoryTarget.innerHTML = data.category.name
        this.groupTarget.innerHTML = data.group.name
        this.subtotalTarget.innerHTML = appraisalSellPrice.toLocaleString()
        this.quantityTarget.value = 1
        this.priceTarget.value = appraisalSellPrice.toFixed(2)
        this.subtotalFieldTarget.value = appraisalSellPrice
        this.subtotalFieldTarget.dispatchEvent(new Event('change'))

        if(data.appraisal_buy_price) {
          this.buyPriceTarget.innerHTML = data.appraisal_buy_price.toLocaleString()
        }

        if(data.appraisal_mid_price) {
          this.sellPriceTarget.innerHTML = data.appraisal_sell_price.toLocaleString()
        }

        if(data.appraisal_mid_price) {
          this.splitPriceTarget.innerHTML = data.appraisal_mid_price.toLocaleString()
        }

        this.itemTarget.classList.remove('hidden')
      })
  }

  calculateTotal(_event) {
    const subtotal = (Math.round(((Number(this.quantityTarget.value) * Number(this.priceTarget.value)) + Number.EPSILON) * 100) / 100)
    this.subtotalTarget.innerHTML = subtotal.toLocaleString()
    this.subtotalFieldTarget.value = subtotal
    this.subtotalFieldTarget.dispatchEvent(new Event('change'))
  }
}
