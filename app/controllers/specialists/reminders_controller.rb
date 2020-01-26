# frozen_string_literal: true

class Specialists::RemindersController < ApplicationController
  before_action :require_specialist!
  before_action :set_business

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
    render 'business/reminders/new'
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.business_id = @business.id
    redirect_to specialists_business_path(@business.username) if @reminder.save
  end

  def destroy
    @reminder = @business.reminders.where(id: params[:id])
    @reminder.first.destroy if @reminder.count.positive?
    redirect_to specialists_business_path(@business.username)
  end

  def update
    @business.reminders.where(id: params[:id]).first.update(done_at: Time.zone.now) if params[:done].present?
    redirect_to specialists_business_path(@business.username)
  end

  private

  def reminder_params
    params.require(:reminder).permit(:body, :remind_at)
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
