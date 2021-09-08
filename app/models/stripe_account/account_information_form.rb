# frozen_string_literal: true

class StripeAccount::AccountInformationForm < StripeAccount
  include ApplicationForm

  validates :business_name, presence: true, if: :company?
  validates :first_name, :last_name, presence: true, if: :individual?

  def self.for(specialist, attributes = {}, stripe_account = nil)
    account = stripe_account || new(specialist: specialist)
    account.attributes = attributes
    account
  end
end
