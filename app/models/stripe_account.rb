# frozen_string_literal: true
class StripeAccount < ActiveRecord::Base
  belongs_to :specialist

  include FileUploader[:verification_document]

  enum status: { pending: 'Pending', verified: 'Verified', error: 'Error' }
  enum account_type: { individual: 'individual', business: 'business' }

  after_create :create_managed_account, :verify_account
  after_destroy :delete_managed_account

  VERIFICATION_FIELDS = {
    all: {
      common: {
        'legal_entity.address.city' => :city,
        'legal_entity.address.line1' => :address1,
        'legal_entity.address.postal_code' => :postal_code,
        'legal_entity.address.state' => :state,
        'legal_entity.dob.day' => -> { dob.day },
        'legal_entity.dob.month' => -> { dob.month },
        'legal_entity.dob.year' => -> { dob.year },
        'legal_entity.first_name' => :first_name,
        'legal_entity.last_name' => :last_name,
        'legal_entity.ssn_last_4' => :ssn_last_4,
        'tos_acceptance.date' => :tos_acceptance_date,
        'tos_acceptance.ip' => :tos_acceptance_ip
      },
      invividual: {},
      business: {
        'legal_entity.business_name' => :business_name,
        'legal_entity.business_tax_id' => :business_tax_id
      }
    },
    'US' => {
      common: {},
      individual: {},
      business: {}
    }
  }.freeze

  private

  def create_managed_account
    # TODO: Bg job?
    account = Stripe::Account.create(
      country: country,
      managed: true,
      external_account: {
        object: 'bank_account',
        country: account_country,
        currency: account_currency,
        routing_number: account_routing_number,
        account_number: account_number
      },
      tos_acceptance: { date: tos_acceptance_date.to_time.to_i, ip: tos_acceptance_ip }
    )
    update_attribute :stripe_id, account.id
  end

  def verify_account
    account = Stripe::Account.retrieve(stripe_id)
    verification_fields.each do |setter, attribute|
      account.public_send "#{setter}=", public_send(attribute)
    end
    account.save
    account = Stripe::Account.retrieve(stripe_id)
    update_attribute :status, account.status
  end

  def verification_fields
    # Common fields for all countries
    # + Individual/business fields for all countries
    # + Common fields for country
    # + Individual/business fields for country
    VERIFICATION_FIELDS[:all][:common]
      .merge(VERIFICATION_FIELDS[:all].fetch(account_type.to_sym))
      .merge(VERIFICATION_FIELDS.fetch(account_country)[:common])
      .merge(VERIFICATION_FIELDS.fetch(account_country).fetch(account_type.to_sym))
  end

  def delete_managed_account
    Stripe::Account.delete stripe_id
  end
end
