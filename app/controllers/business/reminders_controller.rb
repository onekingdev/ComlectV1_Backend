# frozen_string_literal: true

class Business::RemindersController < ApplicationController
  before_action :require_business!
  before_action :set_business

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.business_id = current_business.id
    redirect_to business_dashboard_path if @reminder.save
  end

  def destroy
    @reminder = current_business.reminders.where(id: params[:id])
    @reminder.first.destroy if @reminder.count.positive?
    redirect_to business_dashboard_path
  end

  def update
    current_business.reminders.where(id: params[:id]).first.update(done_at: Time.zone.now) if params[:done].present?
    redirect_to business_dashboard_path
  end

  private

  def reminder_params
    params.require(:reminder).permit(:body, :remind_at)
  end

  def set_business
    @business = current_business
  end
end
