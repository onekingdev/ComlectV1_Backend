# frozen_string_literal: true

class BankAccountSerializer < ApplicationSerializer
  attributes \
    :id,
    :routing_number,
    :account_number,
    :account_number_confirmation
end
