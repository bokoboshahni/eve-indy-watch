import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['subtotal', 'price', 'quantity', 'subtotalField', 'destroy']

  static values = {
    persisted: Boolean
  }

  remove(event) {
    event.preventDefault()

    this.subtotalFieldTarget.value = 0
    this.subtotalFieldTarget.dispatchEvent(new Event('change'))

    if (this.persistedValue) {
      this.element.classList.add('hidden')
      this.destroyTarget.value = '1'
    } else {
      this.element.remove()
    }
  }

  calculateTotal() {
    const subtotal =
      Math.round(
        (Number(this.quantityTarget.value) * Number(this.priceTarget.value) +
          Number.EPSILON) *
          100
      ) / 100
    this.subtotalTarget.innerHTML = subtotal.toLocaleString()
    this.subtotalFieldTarget.value = subtotal
    this.subtotalFieldTarget.dispatchEvent(new Event('change'))
  }
}
