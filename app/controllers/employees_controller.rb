# frozen_string_literal: true

class EmployeesController < ApplicationController
  include RemindersFetcher

  before_action :fetch_invitation, only: %i[new create]
  before_action :authenticate_user!, only: %i[index]
  before_action :require_specialist!, only: %i[index]
  before_action :init_business, only: %i[index]
  before_action :init_tasks_calendar_grid, only: %i[index]

  def index
    @business = current_business
    @reminders_today = reminders_today(current_business)
    @reminders_week = reminders_week(current_business)
    @reminders_past = reminders_past(current_business)
    @ratings = current_business.ratings_received.preload_associations
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
      specialist_params.merge(invitation: @invitation, dashboard_unlocked: true),
      cookies[:referral]
    )
    @specialist.username = @specialist.generate_username
    if @specialist.save(context: :employee)
      @invitation&.accepted!(@specialist)
      sign_in @specialist.user
      @specialist.user.update_privacy_agreement(request.remote_ip)
      @specialist.user.update_cookie_agreement(request.remote_ip)
      # mixpanel_track_later 'Sign Up'
      SpecialistMailer.welcome(@specialist).deliver_later

      attributes_to_delete.each { |c| cookies.delete c }
      return redirect_to specialists_dashboard_path
    end

    render :new
  end

  def fetch_invitation
    @invitation = Specialist::Invitation
                  .where(
                    token: params[:invite_token],
                    status: Specialist::Invitation.statuses[:pending]
                  )
                  .where.not(team_id: nil)
                  .first
  end

  def specialist_params
    params.require(:specialist).permit(
      :first_name, :last_name,
      user_attributes: [:email, :password,
                        tos_agreement_attributes: %i[status tos_description],
                        cookie_agreement_attributes: %i[status cookie_description]]
    ).merge(tos_acceptance_ip: request.remote_ip)
  end

  def init_business
    @invitation = Specialist::Invitation
                  .where(status: Specialist::Invitation.statuses[:accepted])
                  .where.not(team_id: nil)
                  .first
    return unless @invitation
    session.delete(:employee_business_id)
    session[:employee_business_id] = @invitation&.department&.business_id
  end

  def init_tasks_calendar_grid
    tasks_calendar_grid(current_business)
  end

  def mirror
    business = current_specialist.businesses_to_manage.find_by(id: params[:business_id])
    return redirect_to specialists_projects_path unless business

    impersonate_user(business.user)

    redirect_to business_projects_path
  end

  def stop_mirror
    stop_impersonating_user

    redirect_to specialists_projects_path
  end

  def attributes_to_delete
    %i[
      complect_s_address_1
      complect_s_address_2
      complect_s_city
      complect_s_state
      complect_s_zipcode
      complect_s_user_attributes_email
      complect_s_step21
      complect_s_step4
      complect_s_step5
      complect_s_jur_other
      complect_s_states_canada
      complect_s_states_usa
    ]
  end
end
