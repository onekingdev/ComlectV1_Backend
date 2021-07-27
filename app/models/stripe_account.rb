# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class StripeAccount < ApplicationRecord
  belongs_to :specialist, optional: true
  has_many :bank_accounts, dependent: :destroy
  has_many :transactions, dependent: :nullify, foreign_key: 'payment_target_id'

  scope :primary, -> { where(primary: true) }

  enum status: { pending: 'pending', verified: 'verified', fields_needed: 'fields_needed', error: 'error' }
  enum account_type: { individual: 'individual', company: 'company' }

  attr_accessor :verification_document_data, :verification_document_cache

  before_validation :encode_verification_document
  before_validation :set_ssn_last_4_from_personal_id, if: -> { country == 'US' }
  after_create :create_managed_account, if: -> { stripe_id.blank? }
  after_create :verify_account
  after_destroy :delete_stripe_account, if: -> { stripe_id.present? }

  REQUIRED_FIELDS = {
    additional_owners: { company: %w[AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE SG] },
    state: { both: %w[US AT CA AU] },
    business_name: { company: :all },
    business_tax_id: { company: :all },
    personal_city: { company: %w[BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG] },
    personal_address1: { company: %w[BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG] },
    personal_zipcode: { company: %w[BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG] },
    personal_id_number: { both: %w[US CA HK SG] }
  }.freeze

  FIELDS_NEEDED_MAP = {
    'individual.id_number' => 'Personal ID Number'
  }.freeze

  def verification_missing?
    status_detail == 'Verification missing'
  end

  def fields_needed_message(account)
    return 'Please add a bank account' if account.requirements&.currently_due == %w[external_account]

    fields = (account.requirements&.currently_due || []).map do |field|
      next if field == 'external_account'
      FIELDS_NEEDED_MAP[field] || field.split('.')[-1]
    end.compact

    if fields == ['document']
      'Verification missing'
    elsif fields.any?
      "Required information: #{fields.to_sentence}"
    end
  end

  def status_from_account(account)
    if account.requirements&.currently_due&.include?('external_account')
      self.class.statuses[:pending]
    else
      account.requirements&.currently_due&.empty? ? self.class.statuses[:verified] : self.class.statuses[:fields_needed]
    end
  end

  def update_status_from_stripe(account)
    update_columns(
      status: status_from_account(account),
      status_detail: fields_needed_message(account).presence,
      personal_id_number: nil
    )

    Notification::Deliver.verification_missing!(specialist.user) if verification_missing?
  end

  def update_verification_status
    account = Stripe::Account.retrieve(stripe_id)
    update_status_from_stripe account
  end

  private

  def set_ssn_last_4_from_personal_id
    self.ssn_last_4 = personal_id_number.to_s[-4..-1]
  end

  def encode_verification_document
    if verification_document_data.present?
      self.verification_document = Base64.encode64(verification_document_data.read)
    elsif verification_document_cache.present?
      self.verification_document = verification_document_cache
    end

    true
  end

  def create_managed_account
    account = Stripe::Account.create(stripe_attributes)
    update_columns(stripe_id: account.id)
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    destroy # So #persisted? does not return true
    raise ActiveRecord::Rollback
  end

  def stripe_attributes
    attributes = {
      business_type: account_type,
      business_profile: {
        url: "https://app.complect.com/specialists/#{specialist.username}"
      },
      country: country,
      type: :custom,
      tos_acceptance: { date: tos_acceptance_date.to_i, ip: tos_acceptance_ip },
      settings: {
        payouts: {
          debit_negative_balances: true
        }
      },
      requested_capabilities: %w[transfers]
    }

    if individual?
      attributes[:individual] = {
        first_name: first_name
      }
    elsif company?
      attributes[:company] = {
        name: business_name
      }
    end

    attributes
  end

  def verify_account
    account = Stripe::Account.retrieve(stripe_id)

    assign_individual_fields(account) if individual?
    assign_company_fields(account) if company?
    account.save

    update_verification_status
  rescue Stripe::InvalidRequestError => e
    errors.add :base, translate_stripe_error(e.message)
    raise ActiveRecord::Rollback if stripe_id.blank?
    update_attribute :status_detail, translate_stripe_error(e.message)
  end

  def upload_verification_document
    return false if verification_document.blank?
    tmp = Tempfile.new
    tmp.binmode
    tmp.write Base64.decode64(verification_document)
    tmp.close
    file = File.new(tmp.path)
    Stripe::FileUpload.create(
      { purpose: 'identity_document', file: file },
      stripe_account: stripe_id
    )
  end

  def delete_stripe_account
    account = Stripe::Account.retrieve(stripe_id)
    account.delete
  end

  INDIVIDUAL_FIELD_MAPPINGS = {
    'individual.address.line1' => :address1,
    'individual.address.city' => :city,
    'individual.address.state' => :state,
    'individual.address.postal_code' => :zipcode,
    'individual.id_number' => :personal_id_number,
    'individual.dob.day' => -> { dob.day },
    'individual.dob.month' => -> { dob.month },
    'individual.dob.year' => -> { dob.year },
    'individual.first_name' => :first_name,
    'individual.last_name' => :last_name,
    'individual.ssn_last_4' => :ssn_last_4
  }.freeze

  COMPANY_FIELD_MAPPINGS = {
    'company.address.line1' => :address1,
    'company.address.city' => :city,
    'company.address.state' => :state,
    'company.address.postal_code' => :zipcode,
    'company.name' => :business_name,
    'company.tax_id' => :business_tax_id
  }.freeze

  def assign_individual_fields(account)
    INDIVIDUAL_FIELD_MAPPINGS.each do |field, value|
      if value.is_a?(Proc)
        assign_account_field account, field, instance_exec(&value)
      else
        assign_account_field account, field, public_send(value)
      end
    end

    return unless verification_document_data
    upload = upload_verification_document
    account.individual.verification.document = upload.id if upload
  end

  def assign_company_fields(account)
    COMPANY_FIELD_MAPPINGS.each do |field, value|
      if value.is_a?(Proc)
        assign_account_field account, field, instance_exec(&value)
      else
        assign_account_field account, field, public_send(value)
      end
    end

    return unless verification_document_data
    upload = upload_verification_document
    account.company.verification.document = upload.id if upload
  end

  def assign_account_field(account, field, value)
    return if value.blank?
    methods = field.split('.')
    # Chain method calls except last one
    methods[0..-2].inject(account) do |acc, method|
      acc.public_send method
    end.public_send("#{methods.last}=", value)
  end

  STRIPE_ERRORS = {
    /Cannot provide both personal_id_number/i => 'Personal ID number and last 4 SSN digits must match'
  }.freeze

  def translate_stripe_error(error)
    (STRIPE_ERRORS.detect { |regex, _m| regex.match(error) } || [nil, error])[1]
  end
end
# rubocop:enable Metrics/ClassLength
