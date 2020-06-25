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

    redirect_to redirect_path if @reminder.save
  end

  def destroy
    @reminder = @business.reminders.find(params[:id])
    tgt_date = @reminder&.remind_at
    @reminder&.destroy
    redirect_to specialists_business_path(@business.username, reminder: tgt_date&.strftime('%Y-%m-%d'))
  end

  def index
    respond_to do |format|
      format.pdf do
        render pdf: 'reminders.pdf',
               template: 'business/reminders/index.pdf.erb', encoding: 'UTF-8',
               locals: { reminders: @business.reminders_this_year, business: @business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  def update
    # reminder = @business.reminders.find_by(id: params[:id])
    # reminder&.update(
    #   reminder_params.merge(
    #     done_at: (params[:done] == 'true' ? Time.zone.now : nil)
    #   )
    # )
    if params[:done].present?
      @business.reminders
               .where(id: params[:id])
               .first
               .update(
                 done_at: (params[:done] == 'false' ? nil : Time.zone.now)
               )
    end
    respond_to do |format|
      format.html do
        redirect_to redirect_path(@business.username)
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
    @business = current_business || current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end

  def redirect_path(reminder = nil)
    if current_specialist&.employee?(current_business)
      employees_path
    else
      opts = {
        id: @business&.username
      }
      opts[:reminder] = reminder&.remind_at&.strftime('%Y-%m-%d') if reminder

      specialists_business_path(opts)
    end
  end
end
