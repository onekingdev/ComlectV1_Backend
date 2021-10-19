# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes \
    :id,
    :plan,
    :title,
    :status,
    :interval,
    :currency,
    :trial_end,
    :created_at,
    :updated_at,
    :price_interval,
    :amount_in_cents,
    :next_payment_date

  def next_payment_date
    object.next_payment_date&.strftime('%B %d, %Y')
  end

  def amount_in_cents
    object.amount.to_i
  end

  def trial_end
    object.trial_end.strftime('%B %d, %Y') if object.trial_end.present?
  end
end
