# frozen_string_literal: true

class BusinessDashboardController < ApplicationController
  before_action :require_business!

  def show
    current_business.update(review_declined: true) if params[:review] == 'declined'
    @business = current_user.business
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = current_business.reminders.where(remind_at: Time.zone.today)
    @reminders_week = current_business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today, Time.zone.today + 1.week)
  end
end
