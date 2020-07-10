# frozen_string_literal: true

module SubscriptionHelper
  def need_subscription?
    %w[registration_and_maintenance compliance_command_center].include?(current_business&.business_stages)
  end

  def card_formatted(payment_source)
    return unless payment_source

    res = [payment_source.brand, '****']

    res << '**** ****' if payment_source.type.nil?
    res << payment_source.last4
    res.join(' ')
  end

  def billing_date(db_sub)
    if db_sub.billing_period_ends.present?
      if db_sub.billing_period_ends > Time.now.utc.to_i
        db_sub.billing_period_ends
      else
        (db_sub.billing_period_ends + 1.year).to_i
      end
    else
      res = db_sub.created_at.change(year: Time.now.utc.year)
      res = (res + 1.year) if res.to_i < Time.now.utc.to_i
      res.to_i
    end
  end
end
