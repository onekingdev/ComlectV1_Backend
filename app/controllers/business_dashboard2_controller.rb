# frozen_string_literal: true

class BusinessDashboard2Controller < ApplicationController
  include RemindersFetcher
  include ChartData

  before_action :require_business!
  before_action :business_payment_profile?
  before_action :beginning_of_week

  def show
    @range_axis = []
    @financials = Business::Financials.for(current_business)
    @business = current_user.business
    @compliance_spend = ['Spent'] + transactions_monthly(@business)
    @seats_total = current_business.seats.count
    @seats_available = current_business.seats.available.count
    @seats_taken = @seats_total - @seats_available
    @business.spawn_compliance_policies
    if current_business.ria_dashboard?
      assigned_team_members_ids = current_business.seats.pluck(:team_member_id).compact
      @assigned_team_members = TeamMember.where(id: assigned_team_members_ids)
    end
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_association
    @reminders_past = reminders_past(current_business)
    # @reminders_today = reminders_today(current_business, @calendar_grid)
    # @reminders_week = reminders_week(current_business, @calendar_grid)
    @calendar_grid = tasks_calendar_grid(current_business, Date.parse(params[:start_date]).beginning_of_month) if params[:start_date]
    @current_year_annual_review = @business.processed_annual_reviews.where(year: Time.zone.today.year)
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @calendar_grid
      end
    end
  end

  def show_2
    render :html => '<business-dashboard-page></business-dashboard-page>'.html_safe, :layout => 'vue'
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :monday
  end

  def business_payment_profile?
    redirect_to '/business/onboarding' if current_business && !current_business.onboarding_passed
  end
end
