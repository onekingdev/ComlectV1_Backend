# Schema
# t.belongs_to :business, index: true
# t.integer :billing_type, default: 0
# t.integer :level, default: 0
# t.boolean :suspended, default: false
# t.datetime :expiration
# t.timestamps null: false
# t.integer :fee
# t.string :stripe_customer_id

class ForumSubscription < ActiveRecord::Base
  belongs_to :business
  has_many :subscription_charges

  enum billing_type: [ :annual, :monthly ]
  enum level: [ :free, :basic, :pro ]

  after_create :create_subscription

  def get_plan_id
    "#{Rails.env == "production" ? "production" : "staging"}_#{self.level}_#{self.billing_type}"
  end

  def create_subscription
    self.update_attributes(:stripe_customer_id => self.business.payment_profile.stripe_customer_id)
    begin
      sub = Stripe::Subscription.create({
        customer: self.stripe_customer_id,
        items: [{plan: self.get_plan_id}],
      })
    rescue => e
      puts e
    end
  end


end
