# frozen_string_literal: true

class Specialists::BusinessesController < ApplicationController
  include RemindersFetcher

  before_action :beginning_of_week

  def index; end

  def show
    @business = Business.find_by(username: params[:id])
    return unless current_specialist.manageable_ria_businesses.include? @business
    tasks_calendar_grid(@business)
    @financials = Business::Financials.for(@business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = reminders_today(@business)
    @reminders_week = reminders_week(@business)
    @reminders_past = reminders_past(@business)
    @current_year_annual_review = @business.processed_annual_reviews.where(year: Time.zone.today.year)
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :monday
  end
end
