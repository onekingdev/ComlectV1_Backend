# frozen_string_literal: true
class StripeAccount::Form < StripeAccount
  include ApplicationForm

  validates :country, :account_currency, :account_number, :address1, :city, :first_name, :last_name, :dob,
            presence: true
  validates :zipcode, presence: true, unless: -> { country == 'HK' }
  validates :state, presence: true, unless: -> { country == 'SG' }
  validates :account_routing_number, presence: true, unless: :require_iban?
  validates :account_type, inclusion: { in: account_types.values }
  validates :business_name, :business_tax_id, presence: true, if: :company?

  REQUIRED_FIELDS.each do |field, _config|
    validates field, presence: true, if: -> { required?(field) }
  end

  PREPOPULATE_FIELDS = {
    country: -> (specialist) { Stripe::SUPPORTED_COUNTRIES.invert[specialist.country].to_s },
    zipcode: :zipcode,
    city: :city,
    state: :state,
    address1: :address_1,
    personal_city: :city,
    personal_zipcode: :zipcode,
    first_name: :first_name,
    last_name: :last_name,
    tos_acceptance_date: -> (specialist) { specialist.user.tos_acceptance_date },
    tos_acceptance_ip: -> (specialist) { specialist.user.tos_acceptance_ip }
  }.freeze

  def self.for(specialist, attributes = {})
    where(specialist: specialist).first_or_initialize.tap do |account|
      PREPOPULATE_FIELDS.each do |field, specialist_field|
        value = if specialist_field.is_a?(Proc)
                  specialist_field.call(specialist)
                else
                  specialist.public_send(specialist_field)
                end
        account.public_send("#{field}=", value) if account.public_send(field).blank?
      end
      account.attributes = attributes
      account.state = 'Hong Kong' if account.country == 'HK'
      account.ssn_last_4 = account.personal_id_number[-4..-1] if account.country == 'US'
    end
  end

  def update_and_verify(attributes)
    self.class.transaction do
      update_attributes! attributes
      return true if verify_account
      errors.add :base, 'Could not verify account info with Stripe'
      raise ActiveRecord::Rollback
    end
  end

  def require_iban?
    %w(AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE).include? country
  end

  def required?(field)
    return false unless REQUIRED_FIELDS.key?(field)
    base = REQUIRED_FIELDS[field][:both] || REQUIRED_FIELDS[field][account_type.to_sym] || {}
    base == :all || base.include?(country.to_s.upcase)
  end
end
