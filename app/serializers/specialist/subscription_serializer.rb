# frozen_string_literal: true

class Specialist::SubscriptionSerializer < SubscriptionSerializer
  attributes :last4

  def last4
    object.specialist_payment_source&.last4
  end
end
