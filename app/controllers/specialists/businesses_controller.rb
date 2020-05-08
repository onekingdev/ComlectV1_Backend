# frozen_string_literal: true

class Specialists::BusinessesController < ApplicationController
  def index; end

  def show
    business = Business.find_by(username: params[:id])
    return unless current_specialist.manageable_ria_businesses.include? business

    @business = business
    @financials = Business::Financials.for(@business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = @business
                       .reminders
                       .where(remind_at: Time.zone.today)
                       .order(remind_at: :asc, id: :asc)
    @reminders_week = @business
                      .reminders
                      .where('remind_at > ? AND remind_at < ?', Time.zone.today, Time.zone.today + 1.week)
                      .order(remind_at: :asc, id: :asc)
    @reminders_past = @business
                      .reminders
                      .where('remind_at > ? AND remind_at < ?', Time.zone.today - 1.week, Time.zone.today)
                      .where(done_at: nil)
                      .order(remind_at: :asc, id: :asc)
  end
end
