# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes :id,
             :plan,
             :created_at,
             :updated_at,
             :kind_of,
             :title,
             :billing_period_ends_at,
             :status

  def billing_period_ends_at
    Time.at(object.billing_period_ends).utc
  end
end
