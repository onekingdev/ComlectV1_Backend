# frozen_string_literal: true

class Business::RemindersController < ApplicationController
  before_action :require_business!
  before_action :set_business

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
    @reminder.end_date = @parsed_date
    @action_path = business_reminders_path
  end

  def edit
    @reminder = @business.reminders.find(params[:id])
    @action_path = business_reminder_path(@reminder)
    render 'business/reminders/new'
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = current_business.id
    @reminder.remindable_type = 'Business'
    redirect_to business_dashboard_path(reminder: @reminder.remind_at.strftime('%Y-%m-%d')) if @reminder.save
  end

  def destroy
    @reminder = current_business.reminders.find(params[:id])
    tgt_date = @reminder&.remind_at
    @reminder&.destroy
    redirect_to business_dashboard_path(reminder: tgt_date&.strftime('%Y-%m-%d'))
  end

  def index
    respond_to do |format|
      format.pdf do
        render pdf: 'reminders.pdf',
               template: 'business/reminders/index.pdf.erb', encoding: 'UTF-8',
               locals: { remindable: current_business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  def update
    @reminder = current_business.reminders.find(params[:id])
    @reminder.update(done_at: (params[:done] == 'false' ? nil : Time.zone.now)) if params[:done].present?
    @reminder.update(reminder_params) if params[:reminder]
    respond_to do |format|
      format.html do
        redirect_to business_dashboard_path
      end
      format.json do
        render json: :ok
      end
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:body, :remind_at, :end_date)
  end

  def set_business
    @business = current_business
  end
end
