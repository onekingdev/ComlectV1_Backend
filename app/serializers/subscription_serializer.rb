# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes \
    :id,
    :plan,
    :title,
    :last4,
    :status,
    :kind_of,
    :interval,
    :currency,
    :created_at,
    :updated_at,
    :price_interval,
    :amount_in_cents,
    :total_seat_count,
    :next_payment_date

  def last4
    object.payment_source&.last4
  end

  def total_seat_count
    object.seats.count
  end

  def next_payment_date
    object.next_payment_date&.strftime('%B %d, %Y')
  end

  def amount_in_cents
    object.amount.to_i
  end
end
