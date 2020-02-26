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
               locals: { reminders: current_business.reminders_this_year, business: current_business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  # rubocop:disable Metrics/LineLength
  def update
    current_business.reminders.where(id: params[:id]).first.update(done_at: (params[:done] == 'false' ? nil : Time.zone.now)) if params[:done].present?
    respond_to do |format|
      format.html do
        redirect_to business_dashboard_path
      end
      format.json do
        render json: :ok
      end
    end
  end
  # rubocop:enable Metrics/LineLength

  private

  def reminder_params
    params.require(:reminder).permit(:body, :remind_at)
  end

  def set_business
    @business = current_business
  end
end
