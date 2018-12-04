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

  before_create :set_bill_date

  def set_bill_date
    if self.annual?
      self.annual_bill_date = Time.zone.now.strftime("%m %d")
    elsif self.monthly?
      self.monthly_bill_date = Time.zone.now.strftime("%d")
    end
  end

end
