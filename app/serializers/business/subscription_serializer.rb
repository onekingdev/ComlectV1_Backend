# frozen_string_literal: true

class Business::SubscriptionSerializer < SubscriptionSerializer
  attributes \
    :last4,
    :total_seat_count,
    :available_seat_count

  def last4
    object.payment_source&.last4
  end

  def total_seat_count
    object.business.seats.count
  end

  def available_seat_count
    object.business.seats.available.count
  end
end
