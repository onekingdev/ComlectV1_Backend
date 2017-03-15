# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class StripeAccount < ActiveRecord::Base
  belongs_to :specialist
  has_many :transactions, dependent: :nullify, foreign_key: 'payment_target_id'

  scope :sorted, -> { order('"primary" DESC, created_at DESC') }
  scope :primary, -> { where(primary: true) }

  enum status: { pending: 'pending', verified: 'verified', fields_needed: 'fields_needed', error: 'error' }
  enum account_type: { individual: 'individual', company: 'company' }

  attr_accessor :verification_document_data, :verification_document_cache

  before_validation :encode_verification_document
  before_validation :set_ssn_last_4_from_personal_id, if: -> { country == 'US' }
  after_create :create_managed_account, if: -> { specialist.stripe_account_id.blank? }
  after_create :create_bank_account, if: -> { stripe_id.blank? }
  after_create :verify_account
  after_save :sync_all_accounts
  after_destroy :delete_bank_account, if: -> { stripe_id.present? }

  REQUIRED_FIELDS = {
    additional_owners: { company: %w(AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE SG) },
    state: { both: %w(US AT CA AU) },
    business_name: { company: :all },
    business_tax_id: { company: :all },
    personal_city: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_address1: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_zipcode: { company: %w(BE DE DK ES FI FR GB HK IE IT LU NL NO PT SE SG) },
    personal_id_number: { both: %w(US CA HK SG) }
  }.freeze

  FIELDS_NEEDED_MAP = {
    'legal_entity.personal_id_number' => 'Personal ID Number'
  }.freeze

  def fields_needed_message(account)
    fields = (account.verification&.fields_needed || []).map do |field|
      FIELDS_NEEDED_MAP[field] || field.split('.')[-1]
    end
    "Required information: #{fields.to_sentence}" if fields.any?
  end

  def status_from_account(account)
    account.verification.fields_needed.empty? ? self.class.statuses[:verified] : self.class.statuses[:fields_needed]
  end

  def update_status_from_stripe(account)
    update_columns status: status_from_account(account), status_detail: fields_needed_message(account).presence
  end

  private

  # These fields belong to the connected account so they're shared across all bank accounts
  SHARED_ATTRIBUTES = %i(city address1 zipcode personal_city personal_address1 personal_zipcode state dob ssn_last_4
                         personal_id_number business_name business_tax_id).freeze
  def sync_all_accounts
    return if specialist.stripe_accounts.count == 1
    attributes = SHARED_ATTRIBUTES.each_with_object({}) do |attr, attrs|
      attrs[attr] = public_send(attr)
    end
    specialist.stripe_accounts.update_all(attributes)
  end

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
    account = Stripe::Account.create(stripe_account_attributes)
    specialist.update_columns stripe_account_id: account.id,
                              stripe_secret_key: account.keys.secret,
                              stripe_publishable_key: account.keys.publishable
    update_column :stripe_id, account.external_accounts.first.id
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    destroy # So #persisted? does not return true
    raise ActiveRecord::Rollback
  end

  def create_bank_account
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    ba = account.external_accounts.create(external_account: stripe_external_account_attributes)
    update_attribute :stripe_id, ba.id
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    destroy # So #persisted? does not return true
    raise ActiveRecord::Rollback
  end

  def stripe_account_attributes
    {
      country: country,
      managed: true,
      external_account: stripe_external_account_attributes,
      tos_acceptance: { date: tos_acceptance_date.to_i, ip: tos_acceptance_ip }
    }
  end

  def stripe_external_account_attributes
    {
      object: 'bank_account',
      country: country,
      currency: account_currency,
      routing_number: account_routing_number,
      account_number: account_number
    }
  end

  def verify_account
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    assign_account_fields account
    account.save
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    update_status_from_stripe account
  rescue Stripe::InvalidRequestError => e
    errors.add :base, translate_stripe_error(e.message)
    raise ActiveRecord::Rollback
  end

  def upload_verification_document
    return false unless verification_document.present?
    tmp = Tempfile.new
    tmp.binmode
    tmp.write Base64.decode64(verification_document)
    tmp.close
    file = File.new(tmp.path)
    Stripe::FileUpload.create(
      { purpose: 'identity_document', file: file },
      stripe_account: specialist.stripe_account_id
    )
  end

  def delete_bank_account
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    account.external_accounts.retrieve(stripe_id).delete
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

  STRIPE_ERRORS = {
    /Cannot provide both personal_id_number/i => 'Personal ID number and last 4 SSN digits must match'
  }.freeze

  def translate_stripe_error(error)
    (STRIPE_ERRORS.detect { |regex, _m| regex.match(error) } || [nil, error])[1]
  end
end
