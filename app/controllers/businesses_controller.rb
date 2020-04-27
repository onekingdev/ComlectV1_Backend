# frozen_string_literal: true

class BusinessesController < ApplicationController
  before_action -> do
    # sign_out(current_user) if current_user
    redirect_to business_path(current_user.business)
  end, if: -> { user_signed_in? && current_user.business }, only: %i[new create]

  before_action :authenticate_user!, only: %i[edit update show]
  before_action :require_business!, only: %i[edit update]

  def show
    @business = Business.includes(:industries).find_by(username: params[:id])
  end

  def new
    @business = Business.for_signup
  end

  def create
    @business = Business.for_signup(business_params, cookies[:referral])

    @business.apply_quiz(cookies) if cookies[:complect_step1].present?

    @business.username = @business.generate_username
    @business.client_account_cnt = business_params[:client_account_cnt].to_i
    @business.total_assets = Business.fix_aum(business_params[:total_assets])

    if @business.save
      sign_in @business.user

      @business.user.update_privacy_agreement(request.remote_ip)
      @business.user.update_cookie_agreement(request.remote_ip)

      mixpanel_track_later 'Sign Up'

      BusinessMailer.welcome(@business).deliver_later

      %i[complect_contact_first_name complect_contact_last_name complect_business_name complect_address_1 complect_city complect_state complect_step21 complect_contact_job_title complect_contact_phone complect_address_2 complect_zipcode complect_client_account_cnt complect_total_assets complect_user_attributes_email complect_first_name complect_last_name referral complect_step1 complect_step11 complect_step2 complect_step3 complect_step4 complect_step41 complect_step42 complect_other].each do |c| # rubocop:disable Metrics/LineLength
        cookies.delete c
      end

      return redirect_to business_dashboard_path
    end

    render :new
  end

  def edit
    @business = current_user.business
    render_404 unless @business
  end

  def update
    @business = Business::Form.for_user(current_user)
    respond_to do |format|
      if @business.update(edit_business_params)
        @business.update(total_assets: Business.fix_aum(edit_business_params[:total_assets]))
        if @business.delete_logo == '1'
          format.html { render :edit }
        else
          format.html { return redirect_to_param_or business_dashboard_path }
          format.js { render nothing: true, status: :ok }
        end
      else
        format.html { render :edit }
        format.js { js_alert('Could not save your changes, please try again later.') }
      end
    end
  end

  private

  def business_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name, :contact_email, :contact_job_title, :contact_phone,
      :business_name, :employees, :description, :website, :linkedin_link, :delete_logo,
      :address_1, :address_2, :country, :city, :state, :zipcode, :time_zone,
      :anonymous, :logo, :total_assets, :client_account_cnt,
      industry_ids: [], jurisdiction_ids: [],
      user_attributes: [
        :email, :password,
        tos_agreement_attributes: %i[status tos_description],
        cookie_agreement_attributes: %i[status cookie_description]
      ]
    )
  end

  def edit_business_params
    business_params.except(:user_attributes)
  end
end
