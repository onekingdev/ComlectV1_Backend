# frozen_string_literal: true

class SpecialistsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action -> do
    redirect_to specialist_path(current_user.specialist)
  end, if: -> { user_signed_in? && current_user.specialist }, only: %i[create]

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
    @specialist = Specialist.preload_association.find_by(username: params[:id])
  end

  def new
    render html: content_tag('specialist-onboarding-page', '',
                             ':industry-ids': Industry.all.map(&proc { |ind|
                                                                  { id: ind.id,
                                                                    name: ind.name }
                                                                }).to_json,
                             ':jurisdiction-ids': Jurisdiction.all.map(&proc { |ind|
                                                                          { id: ind.id,
                                                                            name: ind.name }
                                                                        }).to_json,
                             ':sub-industry-ids': sub_industries(true).to_json,
                             ':states': State.fetch_all_usa.to_json,
                             ':timezones': timezones_array.to_json).html_safe, layout: 'vue_onboarding'
  end

  def create
    @specialist = Specialist::Form.signup(
      specialist_params.merge(invitation: @invitation),
      cookies[:referral]
    )
    @specialist.apply_quiz(cookies)
    @specialist.username = @specialist.generate_username

    @specialist.skip_confirmation!

    if @specialist.save(context: :signup)
      @invitation&.accepted!(@specialist)
      sign_in @specialist.user
      @specialist.user.update_privacy_agreement(request.remote_ip)
      @specialist.user.update_cookie_agreement(request.remote_ip)
      mixpanel_track_later 'Sign Up'
      SpecialistMailer.welcome(@specialist).deliver_later
      %i[complect_s_address_1 complect_s_address_2 complect_s_city complect_s_state complect_s_zipcode complect_s_user_attributes_email complect_s_step21 complect_s_step4 complect_s_step5 complect_s_jur_other complect_s_states_canada complect_s_states_usa].each do |c|
        cookies.delete c
      end

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
        @specialist.update(sub_industries: convert_sub_industries(params[:sub_industry_ids])) if params[:sub_industry_ids].present?
        @specialist.update(sub_jurisdictions: convert_sub_jurisdictions(params[:sub_jurisdiction_ids]))
        @specialist.update(annual_revenue_goal: Business.fix_aum(edit_specialist_params[:annual_revenue_goal]))
        if @specialist.delete_photo? || @specialist.delete_resume?
          format.html { render :edit }
        else
          format.html { return redirect_to_param_or employee_profile_path(id: @specialist) }
          format.js { render nothing: true, status: :ok }
        end
      else
        format.html { render :edit }
        format.js { js_alert('Could not save your changes, please try again later.') }
      end
    end
  end

  private

  def convert_sub_industries(ids)
    return [] if ids.blank?
    tgt_industries = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      if @specialist.industries.collect(&:id).include? c[0]
        tgt_industries.push(Industry.find(c[0]).sub_industries_specialist.split("\r\n")[c[1]])
      end
    end
    tgt_industries
  end

  def convert_sub_jurisdictions(ids)
    return [] if ids.blank?
    tgt_jurisdictions = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      if @specialist.jurisdictions.collect(&:id).include? c[0]
        tgt_jurisdictions.push(Jurisdiction.find(c[0]).sub_jurisdictions_specialist.split("\r\n")[c[1]])
      end
    end
    tgt_jurisdictions
  end

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
      :lng, :contact_phone, :linkedin_link, :public_profile, :former_regulator, :certifications, :photo, :resume,
      :zipcode, :lat, :time_zone, :call_booked, :annual_revenue_goal, :risk_tolerance, :automatching_available,
      jurisdiction_states_usa: [], jurisdiction_states_canada: [],
      jurisdiction_ids: [], industry_ids: [], skill_names: [],
      user_attributes: [:email, :password,
                        tos_agreement_attributes: %i[status tos_description],
                        cookie_agreement_attributes: %i[status cookie_description]]
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
