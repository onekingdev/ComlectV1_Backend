# frozen_string_literal: true

class Specialists::RemindersController < ApplicationController
  include RemindersUpdater

  before_action :require_specialist!
  before_action :set_specialist

  def new
    @reminder = Reminder.new
    @parsed_date = Date.parse(params[:date])
    @reminder.remind_at = @parsed_date
    @reminder.end_date = @parsed_date
    @action_path = specialists_reminders_path
    @reminder.repeat_on = (@reminder.remind_at.wday.zero? ? 7 : @reminder.remind_at.wday).to_s
    render 'business/reminders/new'
  end

  def edit
    @reminder = @specialist.reminders.find(params[:id])
    if params[:date]
      @occurence = Reminder.new(
        body: @reminder.body,
        remind_at: Date.parse(params[:date]),
        end_date: Date.parse(params[:date]) + (@reminder.duration - 1).days
      )
      @occurence_id = params[:oid].to_i if params[:oid]
    end
    @action_path = specialists_reminder_path(@reminder)
    render 'business/reminders/new'
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = @specialist.id
    @reminder.remindable_type = 'Specialist'
    @reminder.repeats = nil if @reminder.repeats.blank?
    @reminder.skip_occurencies = []
    @reminder.done_occurencies = []
    skip_occurence(current_specialist) if params[:src_id]
    redirect_to specialists_dashboard_path(reminder: @reminder.remind_at.strftime('%Y-%m-%d')) if @reminder.save
  end

  def destroy
    @reminder = @specialist.reminders.find(params[:id])
    tgt_date = @reminder&.remind_at
    if params[:oid]
      @reminder.update(skip_occurencies: @reminder.skip_occurencies + [params[:oid].to_i])
    else
      @reminder&.destroy
    end
    redirect_to specialists_dashboard_path(reminder: tgt_date&.strftime('%Y-%m-%d'))
  end

  def index
    respond_to do |format|
      format.pdf do
        render pdf: 'reminders.pdf',
               template: 'business/reminders/index.pdf.erb', encoding: 'UTF-8',
               locals: { remindable: @specialist },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  def update
    @reminder = @specialist.reminders.find(params[:id])
    change_reminder_state if params[:done].present?
    @reminder.update(reminder_params) if params[:reminder]
    @reminder.update(repeats: nil) if @reminder.repeats.blank?
    respond_to do |format|
      format.html do
        redirect_to specialists_dashboard_path
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

  def set_specialist
    @specialist = current_specialist
  end
end
