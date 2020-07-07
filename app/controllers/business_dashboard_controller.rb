# frozen_string_literal: true

class BusinessDashboardController < ApplicationController
  include RemindersFetcher

  before_action :require_business!
  before_action :business_payment_profile?
  before_action :beginning_of_week
  before_action :init_tasks_calendar_grid

  def show
    @range_axis = []

    @business = current_user.business
    @business.spawn_compliance_policies
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = reminders_today(current_business)
    @reminders_week = reminders_week(current_business)
    @reminders_past = reminders_past(current_business)
    @current_year_annual_review = @business.processed_annual_reviews.where(year: Time.zone.today.year)
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def business_payment_profile?
    redirect_to '/business/onboarding' if current_business && !current_business.onboarding_passed
  end

  def init_tasks_calendar_grid
    tasks_calendar_grid(current_business)
  end
end
