# frozen_string_literal: true

class SubscriptionCharge < ActiveRecord::Base
  belongs_to :forum_subscription
  enum status: %i[failed paid]
end
