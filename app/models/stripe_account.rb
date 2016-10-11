# frozen_string_literal: true
class StripeAccount < ActiveRecord::Base
  belongs_to :specialist

  enum status: { pending: 'pending', verified: 'verified', fields_needed: 'fields_needed', error: 'error' }
  enum account_type: { individual: 'individual', company: 'company' }

  attr_accessor :verification_document_data, :verification_document_cache

  before_validation :encode_verification_document
  after_create :create_managed_account, :verify_account
  after_destroy :delete_managed_account

  REQUIRED_FIELDS = {
    additional_owners: { company: %w(AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE SG) },
    state: { both: %w(US AT CA) },
    business_name: { company: :all },
    business_tax_id: { company: :all },
    personal_city: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_address1: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_zipcode: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_id_number: { both: %w(CA HK) },
    ssn_last_4: { both: %w(US) }
  }.freeze

  private

  def encode_verification_document
    if verification_document_data.present?
      self.verification_document = Base64.encode64(verification_document_data.read)
    elsif verification_document_cache.present?
      self.verification_document = verification_document_cache
    end
    true
  end

  def create_managed_account
    account = Stripe::Account.create(
      country: country,
      managed: true,
      external_account: {
        object: 'bank_account',
        country: country,
        currency: account_currency,
        routing_number: account_routing_number,
        account_number: account_number
      },
      tos_acceptance: { date: tos_acceptance_date.to_i, ip: tos_acceptance_ip }
    )
    update_attribute :stripe_id, account.id
  end

  def verify_account
    account = Stripe::Account.retrieve(stripe_id)
    assign_account_fields account
    account.save
    account = Stripe::Account.retrieve(stripe_id)
    update_attribute :status, status_from_account(account)
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    false
  end

  def upload_verification_document
    return false unless verification_document.present?
    tmp = Tempfile.new
    tmp.binmode
    tmp.write Base64.decode64(verification_document)
    tmp.close
    file = File.new(tmp.path)
    Stripe::FileUpload.create({ purpose: 'identity_document', file: file }, stripe_account: stripe_id)
  end

  def delete_managed_account
    Stripe::Account.delete stripe_id
  end

  def status_from_account(account)
    account.verification.fields_needed.empty? ? self.class.statuses[:verified] : self.class.statuses[:fields_needed]
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/AbcSize
  def assign_account_fields(account)
    account.legal_entity.type = account_type if account_type.present?
    account.legal_entity.address.city = city if city.present?
    account.legal_entity.address.line1 = address1 if address1.present?
    account.legal_entity.address.postal_code = zipcode if zipcode.present?
    account.legal_entity.address.state = state if state.present?
    account.legal_entity.personal_address.city = personal_city if personal_city.present?
    account.legal_entity.personal_address.line1 = personal_address1 if personal_address1.present?
    account.legal_entity.personal_address.postal_code = personal_zipcode if personal_zipcode.present?
    account.legal_entity.personal_id_number = personal_id_number if personal_id_number.present?
    account.legal_entity.dob.day = dob.day if dob.present?
    account.legal_entity.dob.month = dob.month if dob.present?
    account.legal_entity.dob.year = dob.year if dob.present?
    account.legal_entity.first_name = first_name if first_name.present?
    account.legal_entity.last_name = last_name if last_name.present?
    account.legal_entity.ssn_last_4 = ssn_last_4 if ssn_last_4.present?
    account.legal_entity.business_name = business_name if business_name.present?
    account.legal_entity.business_tax_id = business_tax_id if business_tax_id.present?
    account.tos_acceptance.date = tos_acceptance_date.to_i if tos_acceptance_date.present?
    account.tos_acceptance.ip = tos_acceptance_ip if tos_acceptance_ip.present?
    upload = upload_verification_document
    account.legal_entity.verification.document = upload.id if upload
  end
end
