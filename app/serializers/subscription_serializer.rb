# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes :id,
             :plan,
             :created_at,
             :updated_at,
             :kind_of,
             :title,
             :status
end
