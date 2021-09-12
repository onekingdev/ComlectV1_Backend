export class BankAccount {
  constructor(options = {}) {
    this.id = options.id,
    this.account_number = options.account_number,
    this.routing_number = options.routing_number
  }
}
