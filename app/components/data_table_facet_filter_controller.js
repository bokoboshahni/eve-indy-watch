import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['query', 'item']

  filter() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const filterTerm = this.queryTarget.value.toLowerCase()

      this.itemTargets.forEach((el) => {
        const filterableKey = el.getAttribute('data-filter-key')

        el.classList.toggle('hidden', !filterableKey.includes(filterTerm))
      })
    }, 200)
  }
}
