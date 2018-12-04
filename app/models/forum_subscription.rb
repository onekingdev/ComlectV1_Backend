# Schema
# t.belongs_to :business, index: true
# t.integer :billing_type, default: 0
# t.integer :level, default: 0
# t.boolean :suspended, default: false
# t.datetime :expiration
# t.timestamps null: false

class ForumSubscription < ActiveRecord::Base
  belongs_to :business

  enum billing_type: [ :annual, :monthly ]
  enum level: [ :free, :basic, :pro ]

  after_create :schedule_payments

  def schedule_payments
    if self.annual?
      schedule_annual_payments
    else
      schedule_monthly_payments
    end
  end

  def schedule_monthly_payments
    #
  end

  def schedule_annual_payments
    # 
  end

end
