# frozen_string_literal: true

class Api::Specialist::BankAccountsController < ApiController
  before_action :require_specialist!

  def create
    service = SpecialistServices::BankAccountService.call(current_specialist, params)

    if service.success?
      respond_with service.bank_account, serializer: BankAccountSerializer
    else
      respond_with service.bank_account
    end
  end
end
