# frozen_string_literal: true

module SubscriptionCommon
  def add_one_time_payment(db_subscription)
    return if db_subscription&.stripe_invoice_item_id.present?

    one_time_item = Subscription.create_invoice_item(current_business.payment_profile.stripe_customer)
    db_subscription.update(stripe_invoice_item_id: one_time_item.id)
  end
end
