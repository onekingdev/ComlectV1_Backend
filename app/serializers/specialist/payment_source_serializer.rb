# frozen_string_literal: true

class Specialist::PaymentSourceSerializer < ApplicationSerializer
  attributes :id,
             :specialist_id,
             :brand,
             :exp_month,
             :exp_year,
             :last4,
             :primary,
             :country,
             :currency,
             :account_holder_name,
             :account_holder_type,
             :validated,
             :bank_account
end
