# frozen_string_literal: true
class BusinessesController < ApplicationController
  before_action -> do
    redirect_to business_path(current_user.business)
  end, if: -> { signed_in? && current_user.business }, only: %i(new create)

  def show
    @business = Business.includes(:industries).find(params[:id])
  end

  def new
    @business = Business.for_signup
  end

  def create
    @business = Business.for_signup(business_params)
    if @business.save
      sign_in @business.user
      return redirect_to business_dashboard_path
    end
    render :new
  end

  def edit
    @business = current_user.business
    render_404 unless @business
  end

  def update
    @business = current_user.business
    if @business.update_attributes(edit_business_params)
      return redirect_to_param_or business_dashboard_path
    end
    render :edit
  end

  private

  def business_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name, :contact_email, :contact_job_title, :contact_phone,
      :business_name, :employees, :description, :website, :linkedin_link,
      :address_1, :address_2, :country, :city, :state, :zipcode,
      :anonymous, :logo,
      industry_ids: [], jurisdiction_ids: [],
      user_attributes: %i(email password)
    )
  end

  def edit_business_params
    business_params.except(:user_attributes)
  end
end
