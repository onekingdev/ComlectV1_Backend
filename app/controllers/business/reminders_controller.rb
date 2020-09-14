# frozen_string_literal: true

class Business::RemindersController < ApplicationController
  before_action :require_business!
  before_action :set_business

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
    @reminder.end_date = @parsed_date
    @reminder.repeat_on = (@reminder.remind_at.wday.zero? ? 7 : @reminder.remind_at.wday).to_s
    @action_path = business_reminders_path
  end

  def edit
    @reminder = @business.reminders.find(params[:id])
    if params[:date]
      @occurence = Reminder.new(
        body: @reminder.body,
        remind_at: Date.parse(params[:date]),
        end_date: Date.parse(params[:date]) + (@reminder.duration - 1).days
      )
      @occurence_id = params[:oid].to_i if params[:oid]
    end
    @action_path = business_reminder_path(@reminder)
    render 'business/reminders/new'
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = current_business.id
    @reminder.remindable_type = 'Business'
    @reminder.repeats = nil if @reminder.repeats.blank?
    @reminder.skip_occurencies = []
    @reminder.done_occurencies = []
    if params[:src_id]
      src_reminder = current_business.reminders.where(id: params[:src_id].to_i)
      if src_reminder.count.positive?
        src_reminder.first.update(skip_occurencies: src_reminder.first.skip_occurencies + [params[:oid].to_i])
      end
    end
    redirect_to business_dashboard_path(reminder: @reminder.remind_at.strftime('%Y-%m-%d')) if @reminder.save
  end

  def destroy
    @reminder = current_business.reminders.find(params[:id])
    tgt_date = @reminder&.remind_at
    if params[:oid]
      @reminder.update(skip_occurencies: @reminder.skip_occurencies + [params[:oid].to_i])
    else
      @reminder&.destroy
    end
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
    if params[:done].present?
      if params[:oid].present?
        @reminder.update(done_occurencies: @reminder.done_occurencies + [params[:oid].to_i])
      else
        @reminder.update(done_at: (params[:done] == 'false' ? nil : Time.zone.now))
      end
    end
    @reminder.update(reminder_params) if params[:reminder]
    @reminder.update(repeats: nil) if @reminder.repeats.blank?
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
    params.require(:reminder).permit(:body, :remind_at, :end_date, :repeats, :end_by, :repeat_every, :repeat_on, :on_type)
  end

  def set_business
    @business = current_business
  end
end
