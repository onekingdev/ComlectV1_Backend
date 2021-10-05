# frozen_string_literal: true

class Api::Specialist::UpgradesController < ApiController
  before_action :require_specialist!

  def create
    service = SpecialistServices::StripeSubscriptionService.call(
      current_specialist, plan_params
    )

    if service.success?
      plan_name = service.subscription.title
      respond_with message: t('.notice', plan_name: plan_name), status: :created
    else
      render json: { error: service.error }, status: :unprocessable_entity
    end
  end

  private

  def plan_params
    params.require(:upgrade).permit(:plan, :coupon_id)
  end
end
