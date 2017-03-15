# frozen_string_literal: true
class StripeAccount::Form < StripeAccount
  include ApplicationForm

  validates :country, :address1, :city, :first_name, :last_name, :dob, presence: true
  validates :zipcode, presence: true, unless: -> { country == 'HK' }
  validates :state, presence: true, unless: -> { country == 'SG' }
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

  def self.find(specialist, id)
    where(specialist: specialist).find(id)
  end

  def self.for(specialist, attributes = {})
    account = find_by(specialist_id: specialist.id) || new(specialist: specialist)
    prepopulate account, specialist
    account.attributes = attributes
    account.account_type = 'individual' if Stripe::INDIVIDUAL_ONLY_COUNTRIES.include?(account.country)
    # account.primary = true unless existing
    account.state = 'Hong Kong' if account.country == 'HK'
    account
  end

  def self.prepopulate(account, specialist)
    PREPOPULATE_FIELDS.each do |field, specialist_field|
      value = if specialist_field.is_a?(Proc)
                specialist_field.call(specialist)
              else
                specialist.public_send(specialist_field)
              end
      account.public_send("#{field}=", value) if account.public_send(field).blank?
    end
  end

  def update_and_verify(attributes)
    self.class.transaction do
      update_attributes! attributes
      verify_account
      return true if errors.empty?
      raise ActiveRecord::Rollback
    end
  end

  def required?(field)
    return false unless REQUIRED_FIELDS.key?(field)
    base = REQUIRED_FIELDS[field][:both] || REQUIRED_FIELDS[field][account_type.to_sym] || {}
    base == :all || base.include?(country.to_s.upcase)
  end
end
