import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'itemSubtotal', 'subtotal', 'multiplier', 'subtotalWithMultiplier', 'bonus', 'total', 'price',
    'items', 'itemSearch', 'type'
  ]

  static values = {
    order: String
  }

  connect() {
    document.addEventListener('autocomplete.change', this.addItem.bind(this))
  }

  addItem(event) {
    event.preventDefault()


    const url = this.buildItemURL(this.itemSearchTarget.value)
    this.itemSearchTarget.value = ''
    fetch(url)
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        this.itemsTarget.append(doc.querySelector('li'))
        this.calculateTotal()
      })
  }

  buildItemURL(typeID) {
    const url = new URL('/orders/item', window.location.href)

    const params = new URLSearchParams(url.search.slice(1))
    params.append("order_id", this.orderValue)
    params.append("type_id", typeID)
    url.search = params.toString()

    return url.toString()
  }

  calculateTotal() {
    const subtotal = this.itemSubtotalTargets.map(t => Number(t.value)).reduce((s, a) => s + a, 0)
    this.subtotalTarget.innerHTML = (Math.round((subtotal + Number.EPSILON) * 100) / 100).toLocaleString()

    const subtotalWithMultiplier = (Number(this.multiplierTarget.value) / 100) * subtotal
    this.subtotalWithMultiplierTarget.innerHTML = subtotalWithMultiplier.toLocaleString()

    const bonus = Number(this.bonusTarget.value)

    const total = subtotalWithMultiplier + bonus
    this.totalTarget.innerHTML = total.toLocaleString()
    this.priceTarget.value = total
  }
}
