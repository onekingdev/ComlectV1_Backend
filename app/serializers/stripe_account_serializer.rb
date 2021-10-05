# frozen_string_literal: true

class StripeAccountSerializer < ApplicationSerializer
  attributes \
    :id,
    :dob,
    :city,
    :last4,
    :state,
    :country,
    :zipcode,
    :address1,
    :bank_name,
    :last_name,
    :first_name,
    :account_type,
    :business_name,
    :business_tax_id,
    :personal_id_number

  def country
    country = object.country

    {
      value: country,
      name: Stripe::SUPPORTED_COUNTRIES[country.to_sym]
    }
  end

  def account_type
    account_type = object.account_type

    {
      value: account_type,
      name: account_type == 'company' ? 'Business' : account_type.titleize
    }
  end
end
