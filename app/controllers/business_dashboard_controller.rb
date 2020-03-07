# frozen_string_literal: true

class BusinessDashboardController < ApplicationController
  before_action :require_business!
  before_action :business_payment_profile?

  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/AbcSize
  def show
    current_business.update(review_declined: true) if params[:review] == 'declined'
    @business = current_user.business
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = current_business.reminders.where(remind_at: Time.zone.today).order(remind_at: :asc, id: :asc)
    @reminders_week = current_business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today, Time.zone.today + 1.week).order(remind_at: :asc, id: :asc)
    @reminders_past = current_business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today - 1.week, Time.zone.today).where(done_at: nil).order(remind_at: :asc, id: :asc)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/LineLength

  private

  def business_payment_profile?
    redirect_to '/business/onboarding' if current_business && !current_business.onboarding_passed
  end
end
