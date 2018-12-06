class SubscriptionCharge < ActiveRecord::Base
  belongs_to :forum_subscription
  enum status: [ :failed, :paid ]
end
