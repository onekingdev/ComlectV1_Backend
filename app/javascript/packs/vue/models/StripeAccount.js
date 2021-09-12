export class StripeAccount {
  constructor(options = {}) {
    this.id = options.id
    this.dob = options.dob
    this.city = options.city
    this.state = options.state
    this.country = options.country
    this.zipcode = options.zipcode
    this.address1 = options.address1
    this.last_name = options.last_name
    this.first_name = options.first_name
    this.account_type = options.account_type
    this.business_name = options.business_name
    this.business_tax_id = options.business_tax_id
    this.personal_id_number = options.personal_id_number
  }
}
