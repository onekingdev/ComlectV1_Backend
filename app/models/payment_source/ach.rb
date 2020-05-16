# frozen_string_literal: true

class PaymentSource::ACH < PaymentSource
  attr_accessor :validate1, :validate2
  attr_accessor :plaid_account_id, :plaid_token, :plaid_institution

  class << self
    def plaid_or_manual(business, params)
      return add_to(business, params) if params.is_a?(String) || !params.key?(:plaid_token)
      user = Plaid::User.exchange_token(params.require(:plaid_token), params.require(:plaid_account_id), product: :auth)
      attributes = {
        token: user.stripe_bank_account_token,
        brand: params.require(:plaid_institution),
        last4: '****',
        validated: true
      }
      add_to business, attributes
    end

    private

    def add_to_existing(profile, params)
      source = new(params.merge(payment_profile: profile, primary: profile.payment_sources.empty?))
      source.save if profile.errors.empty?
      source
    rescue Stripe::StripeError => e
      errors.add :base, e.message
      source
    end

    def create_profile_and_add(business, params)
      profile = business.create_payment_profile
      add_to_existing profile, params
    end
  end

  def validate_microdeposits(params)
    account = stripe_customer.sources.retrieve(stripe_id)
    account.verify amounts: [params[:validate1].to_i, params[:validate2].to_i]
    update_attribute :validated, true
  rescue Stripe::CardError => _e
    errors.add :base, "Amounts don't match"
  end

  def bank_account?
    true
  end
end
