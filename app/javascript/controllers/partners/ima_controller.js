import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'premium' ]

  initialize() {
    this.costTable = {
      1000: { 50000: 627, 100000: 1097, 150000: 1567, 200000: 1880 },
      2500: { 50000: 564, 100000: 987, 150000: 1410, 200000: 1692 },
      5000: { 50000: 502, 100000: 878, 150000: 1253, 200000: 1504 }
    }

    this.deductibleAmounts = [1000, 2500, 5000]
    this.revenue = 100000
    this.deductible = 2500
  }

  connect() {
    this.initializeRevenueSlider()
    this.initializeDeductibleSlider()
    this.updatePremium()
  }

  initializeRevenueSlider() {
    $('#revenue-slider').ionRangeSlider({
      type: 'single',
      min: 50000,
      max: 200000,
      from: this.revenue,
      prefix: '$',
      step: 50000,
      prettify_separator: ',',
      onChange: (event) => {
        this.revenue = event.from
        this.updatePremium()
      }
    })
  }

  initializeDeductibleSlider() {
    $('#deductible-slider').ionRangeSlider({
      type: 'single',
      values: this.deductibleAmounts,
      from: 1,
      prefix: '$',
      prettify_separator: ',',
      onChange: (event) => {
        const amount = this.deductibleAmounts[event.from]
        this.deductible = amount
        this.updatePremium()
      }
    })
  }

  updatePremium() {
    let amount = this.costTable[this.deductible][this.revenue]
    this.premiumTarget.textContent = `Premium: \$${amount}`
  }
}
