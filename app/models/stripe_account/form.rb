# frozen_string_literal: true
class StripeAccount::Form < StripeAccount
  include ApplicationForm

  validates :account_country, :account_currency, :account_routing_number, :account_number, :address1, :postal_code,
            :city, :state, :country, :first_name, :last_name, :dob, :ssn_last_4, :personal_id_number,
            :verification_document,
            presence: true
  validates :accept_tos, inclusion: { in: [true] }

  def self.for(specialist)
    where(specialist: specialist).first_or_initialize
  end

  def accept_tos=(value)
    if (@accept_tos = ActiveRecord::Type::Boolean.new.type_cast_from_user(value))
      self.tos_acceptance_date = Time.zone.today
    end
  end

  def accept_tos
    @accept_tos.nil? ? tos_acceptance_date.present? : @accept_tos
  end
end
