# frozen_string_literal: true

class Api::Specialist::BillingsController < ApiController
  before_action :require_specialist!
  before_action :load_stripe_account, only: :update

  def index
    stripe_account = current_specialist.stripe_account

    if stripe_account.present?
      respond_with stripe_account, serializer: StripeAccountSerializer
    else
      render json: {}, status: :ok
    end
  end

  def create
    service = SpecialistServices::StripeAccountService.call(current_specialist, params)

    if service.success?
      respond_with service.stripe_account, serializer: StripeAccountSerializer
    else
      respond_with service.stripe_account
    end
  end

  def update
    service = SpecialistServices::StripeAccountService.call(
      current_specialist,
      params,
      @stripe_account
    )

    if service.success?
      respond_with service.stripe_account, serializer: StripeAccountSerializer
    else
      respond_with service.stripe_account
    end
  end

  private

  def load_stripe_account
    @stripe_account ||= StripeAccount.find(params[:id])
  end
end
