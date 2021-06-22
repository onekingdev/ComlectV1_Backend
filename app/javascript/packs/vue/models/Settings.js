export class SettingsGeneral {
  constructor(city, contact_phone, country, state, time_zone) {
    this.city = city,
    this.contact_phone = contact_phone,
    this.country = country,
    this.state = state,
    this.time_zone = time_zone
  }
}

export class SettingsPaymentMethod {
  constructor(account_holder_name, account_holder_type, brand, country, coupon_id, currency, exp_month, exp_year, id, last4, payment_profile_id, primary, stripe_id, type, validated) {
    this.account_holder_name = account_holder_name,
    this.account_holder_type = account_holder_type,
    this.brand = brand,
    this.country = country,
    this.coupon_id = coupon_id,
    this.currency = currency,
    this.exp_month = exp_month,
    this.exp_year = exp_year,
    this.id = id,
    this.last4 = last4,
    this.payment_profile_id = payment_profile_id,
    this.primary = primary,
    this.stripe_id = stripe_id,
    this.type = type,
    this.validated = validated
  }
}
