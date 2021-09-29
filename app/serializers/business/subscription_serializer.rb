# frozen_string_literal: true

class Business::SubscriptionSerializer < SubscriptionSerializer
  attributes :last4, :total_seat_count

  def last4
    object.payment_source&.last4
  end

  def total_seat_count
    object.seats.count
  end
end
