import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['itemSubtotal', 'subtotal', 'multiplier', 'subtotalWithMultiplier', 'bonus', 'total', 'price']

  calculateTotal(_event) {
    const subtotal = this.itemSubtotalTargets.map(t => Number(t.value)).reduce((s, a) => s + a, 0)
    this.subtotalTarget.innerHTML = (Math.round((subtotal + Number.EPSILON) * 100) / 100).toLocaleString()

    const subtotalWithMultiplier = (Number(this.multiplierTarget.value) / 100) * subtotal
    this.subtotalWithMultiplierTarget.innerHTML = subtotalWithMultiplier.toLocaleString() + ' ISK'

    const bonus = Number(this.bonusTarget.value)

    const total = subtotalWithMultiplier + bonus
    this.totalTarget.innerHTML = total.toLocaleString()
    this.priceTarget.value = total
  }
}
