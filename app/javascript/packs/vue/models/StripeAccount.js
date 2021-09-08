export class StripeAccount {
  constructor(options = {}) {
    this.id = options.id,
    this.country = options.country,
    this.last_name = options.last_name,
    this.first_name = options.first_name,
    this.account_type = options.account_type,
    this.business_name = options.business_name
  }
}
