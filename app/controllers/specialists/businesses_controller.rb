# frozen_string_literal: true

class Specialists::BusinessesController < ApplicationController
  def index; end

  # rubocop:disable Style/GuardClause
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/LineLength
  def show
    business = Business.find_by(username: params[:id])
    if current_specialist.manageable_ria_businesses.include? business
      @business = business
      @business.update(review_declined: true) if params[:review] == 'declined'
      @financials = Business::Financials.for(@business)
      @ratings = @business.ratings_received.preload_associations
      @reminders_today = @business.reminders.where(remind_at: Time.zone.today).order(remind_at: :asc, id: :asc)
      @reminders_week = @business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today, Time.zone.today + 1.week).order(remind_at: :asc, id: :asc)
      @reminders_past = @business.reminders.where('remind_at > ? AND remind_at < ?', Time.zone.today - 1.week, Time.zone.today).where(done_at: nil).order(remind_at: :asc, id: :asc)
    end
  end
  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Style/GuardClause
end
