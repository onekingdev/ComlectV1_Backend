# frozen_string_literal: true

class Api::SpecialistsController < ApiController
  before_action :require_specialist!, only: %i[update current]
  skip_before_action :authenticate_user!, only: :create

  def create
    specialist = Specialist.new(signup_params)

    if specialist.save
      BusinessMailer.verify_email(specialist.user, specialist.user.otp).deliver_later
      render json: { userid: specialist.user_id, message: I18n.t('api.specialists.confirm_otp') }.to_json
    else
      respond_with errors: { specialist: specialist.errors.messages }
    end
  end

  def update
    service = SpecialistServices::SignupOnboardingService.call(
      current_specialist, onboarding_params
    )

    if service.success?
      respond_with service.specialist, serializer: ::SpecialistSerializer
    else
      respond_with errors: { specialist: service.specialist.errors.messages }
    end
  end

  def current
    respond_with current_specialist, serializer: ::SpecialistSerializer
  end

  private

  def signup_params
    params.require(:specialist).permit(
      :first_name, :last_name,
      user_attributes: %i[email password]
    )
  end

  def onboarding_params
    params.require(:specialist).permit(
      :resume,
      :time_zone,
      :experience,
      :former_regulator,
      :specialist_other,
      skill_names: [],
      industry_ids: [],
      jurisdiction_ids: [],
      sub_industry_ids: []
    )
  end
end
