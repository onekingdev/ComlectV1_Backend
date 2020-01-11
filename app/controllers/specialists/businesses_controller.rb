# frozen_string_literal: true

class Specialists::BusinessesController < ApplicationController
  def index; end

  # rubocop:disable Style/GuardClause
  def show
    business = Business.find_by(username: params[:id])
    if current_specialist.manageable_ria_businesses.include? business
      @business = business
      @financials = Business::Financials.for(@business)
      @ratings = @business.ratings_received.preload_associations
      @reminders_today = @business.reminders.where(remind_at: Time.zone.today)
      @reminders_week = @business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today, Time.zone.today + 1.week)
    end
  end
  # rubocop:enable Style/GuardClause
end
