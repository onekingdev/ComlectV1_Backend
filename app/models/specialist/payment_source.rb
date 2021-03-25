# frozen_string_literal: true

class Specialist::PaymentSource < ActiveRecord::Base
  belongs_to :specialist
  attr_accessor :routing_number, :account_number, :validate1, :validate2

  def primary?
    primary == true
  end

  def make_primary!
    specialist.payment_sources.update_all primary: false
    update_attribute :primary, true
  end

  def validate_microdeposits(params)
    if bank_account?
      begin
        customer = Stripe::Customer.retrieve(stripe_customer_id)
        account = customer.sources.retrieve(stripe_card_id)
        account.verify amounts: [params[:validate1].to_i, params[:validate2].to_i]
        update_attribute :validated, true
        response = {
          success: true,
          message:  'Successfully validated'
        }
      rescue
        response = {
          success: false,
          message:  "Amounts don't match"
        }
      end
    else
      response = {
        success: false,
        message: 'Source is not a bank account'
      }
    end
    response
  end
end
