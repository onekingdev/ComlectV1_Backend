# frozen_string_literal: true

class Api::BusinessesController < ApiController
  skip_before_action :authenticate_user!, only: :create
  before_action :require_business!, only: %i[update current]

  def create
    business = Business.new(signup_params)

    if business.save
      business.update_attribute('account_created', true)
      BusinessMailer.verify_email(business.user, business.user.otp).deliver_later
      render json: { userid: business.user_id, message: I18n.t('api.businesses.confirm_otp') }.to_json
    else
      respond_with errors: { business: business.errors.messages }
    end
  end

  def update
    service = BusinessServices::OnboardingService.call(current_business, onboarding_params)

    if service.success?
      respond_with service.business, serializer: BusinessSerializer
    else
      respond_with errors: { business: service.business.errors.messages }
    end
  end

  def current
    respond_with current_business, serializer: BusinessSerializer
  end

  def auto_populate
    crd_number = params[:business][:crd_number]

    if crd_number.blank?
      respond_with(errors: { business: { crd_number: 'Required field' } }) and return
    end

    potential_business = PotentialBusiness.find_by(crd_number: crd_number)

    if potential_business.present?
      business_attrs = potential_business.attributes.except('id', 'created_at', 'updated_at')
      current_business.assign_attributes(business_attrs)
      current_business.save(validate: false)
    else
      current_business.update_attribute(:crd_number, crd_number)
    end

    respond_with current_business.business, serializer: BusinessSerializer
  end

  private

  def signup_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name,
      user_attributes: %i[email password]
    )
  end

  def onboarding_params
    params.require(:business).permit(
      :business_name, :time_zone, :address_1,
      :apartment, :city, :state, :zipcode, :aum,
      :client_account_cnt, :contact_phone, :website,
      industry_ids: [],
      sub_industry_ids: [],
      jurisdiction_ids: []
    )
  end
end
