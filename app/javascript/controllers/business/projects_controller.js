import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      $('#js-help').modal('show')
    }, 15000)
  }
}
