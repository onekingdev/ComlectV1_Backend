# frozen_string_literal: true

class SpecialistsController < ApplicationController
  before_action -> do
    redirect_to specialist_path(current_user.specialist)
  end, if: -> { user_signed_in? && current_user.specialist }, only: %i[new create]

  before_action :authenticate_user!, only: %i[edit update show]
  before_action :require_specialist!, only: %i[edit update]
  before_action :require_business!, only: %i[index]
  before_action :fetch_invitation, only: %i[new create]

  def index
    @search = Specialist::Search.new(search_params)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @specialist = Specialist.preload_associations.find(params[:id])
  end

  def new
    attributes = {
      first_name: @invitation&.first_name,
      last_name: @invitation&.last_name,
      user_attributes: { email: @invitation&.email }
    }

    @specialist = Specialist::Form.signup(attributes)
  end

  def create
    @specialist = Specialist::Form.signup(
      specialist_params.merge(invitation: @invitation),
      cookies[:referral]
    )

    if @specialist.save(context: :signup)
      @invitation&.accepted!(@specialist)
      sign_in @specialist.user
      @specialist.user.update_privacy_agreement(request.remote_ip)
      @specialist.user.update_cookie_agreement(request.remote_ip)
      mixpanel_track_later 'Sign Up'
      SpecialistMailer.welcome(@specialist).deliver_later
      cookies.delete :referral
      return redirect_to specialists_dashboard_path
    end

    render :new
  end

  def edit
    fetch_specialist
  end

  def update
    fetch_specialist

    respond_to do |format|
      if @specialist.update(edit_specialist_params)
        if @specialist.delete_photo? || @specialist.delete_resume?
          format.html { render :edit }
        else
          format.html { return redirect_to_param_or specialists_dashboard_path }
          format.js { render nothing: true, status: :ok }
        end
      else
        format.html { render :edit }
        format.js { js_alert('Could not save your changes, please try again later.') }
      end
    end
  end

  private

  def fetch_invitation
    @invitation = Specialist::Invitation.find_by(
      token: params[:invite_token],
      status: Specialist::Invitation.statuses[:pending]
    )
  end

  def fetch_specialist
    @specialist = Specialist::Form.for_user(current_user)
  end

  def specialist_params
    params.require(:specialist).permit(
      :delete_photo, :delete_resume, :first_name, :last_name, :country, :address_1, :address_2, :state, :city,
      :lng, :phone, :linkedin_link, :public_profile, :former_regulator, :certifications, :photo, :resume,
      :zipcode, :lat, :time_zone,
      jurisdiction_ids: [], industry_ids: [], skill_names: [],
      user_attributes: [:email, :password,
                        tos_agreement_attributes: %i[status tos_description],
                        cookie_agreement_attributes: %i[status cookie_description]],
      work_experiences_attributes: %i[id company job_title location from to current compliance description _destroy],
      education_histories_attributes: %i[id institution degree year _destroy]
    ).merge(tos_acceptance_ip: request.remote_ip)
  end

  def edit_specialist_params
    specialist_params.except(:user_attributes, :tos_acceptance_ip)
  end

  def search_params
    specialist_search_params = params[:specialist_search]
    return params.slice(:page) unless specialist_search_params
    permitted = specialist_search_params.permit(
      :sort_by, :keyword, :rating, :experience, :regulator, :location, :location_range, :lat, :lng, :page,
      industry_ids: [], jurisdiction_ids: []
    )
    permitted.merge!(params.slice(:page)) if permitted[:page].blank? || params[:page].to_i.positive?
    permitted
  end
end
