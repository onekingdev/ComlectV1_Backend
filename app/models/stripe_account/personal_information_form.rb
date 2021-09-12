# frozen_string_literal: true

class StripeAccount::PersonalInformationForm < StripeAccount
  include ApplicationForm

  validates :business_tax_id, presence: true, if: :company?
  validates :personal_id_number, presence: true, if: :individual?
  validates :dob, :city, :state, :zipcode, :address1, presence: true

  validate :validate_age

  def self.for(stripe_account, attributes = {})
    account = find(stripe_account.id)
    account.attributes = attributes
    account
  end
end
