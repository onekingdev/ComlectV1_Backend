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
    update_attribute :status_detail, nil
    true
  rescue Stripe::InvalidRequestError => e
    update_attribute :status, 'error'
    update_attribute :status_detail, e.message
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
    Stripe::Account.retrieve(stripe_id).delete
  end

  def status_from_account(account)
    account.verification.fields_needed.empty? ? self.class.statuses[:verified] : self.class.statuses[:fields_needed]
  end

  FIELD_MAPPINGS = {
    'legal_entity.type' => :account_type,
    'legal_entity.address.city' => :city,
    'legal_entity.address.line1' => :address1,
    'legal_entity.address.postal_code' => :zipcode,
    'legal_entity.address.state' => :state,
    'legal_entity.personal_address.city' => :personal_city,
    'legal_entity.personal_address.line1' => :personal_address1,
    'legal_entity.personal_address.postal_code' => :personal_zipcode,
    'legal_entity.personal_id_number' => :personal_id_number,
    'legal_entity.dob.day' => -> { dob.day },
    'legal_entity.dob.month' => -> { dob.month },
    'legal_entity.dob.year' => -> { dob.year },
    'legal_entity.first_name' => :first_name,
    'legal_entity.last_name' => :last_name,
    'legal_entity.ssn_last_4' => :ssn_last_4,
    'legal_entity.business_name' => :business_name,
    'legal_entity.business_tax_id' => :business_tax_id,
    'tos_acceptance.date' => -> { tos_acceptance_date.to_i },
    'tos_acceptance.ip' => :tos_acceptance_ip
  }.freeze

  def assign_account_fields(account)
    FIELD_MAPPINGS.each do |field, value|
      assign_account_field account, field, value.is_a?(Proc) ? instance_exec(&value) : public_send(value)
    end
    if verification_document_data
      upload = upload_verification_document
      account.legal_entity.verification.document = upload.id if upload
    end
  end

  def assign_account_field(account, field, value)
    return unless value.present?
    methods = field.split('.')
    # Chain method calls except last one
    methods[0..-2].inject(account) do |acc, method|
      acc.public_send method
    end.public_send("#{methods.last}=", value)
  end
end
