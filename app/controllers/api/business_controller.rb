# frozen_string_literal: true

class Api::BusinessController < ApplicationController
  include RemindersFetcher

  before_action :authenticate_user!
  before_action :require_business!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def tasks_by_date
    tasks, projects = tasks_calendar_grid2(current_business, Date.parse(params[:date_from]), Date.parse(params[:date_to]))
    render json: { tasks: tasks, projects: projects }
  end

  def task_create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = current_business.id
    @reminder.remindable_type = 'Business'
    @reminder.repeats = nil if @reminder.repeats.blank?
    @reminder.skip_occurencies = []
    @reminder.done_occurencies = {}
    # skip_occurence(current_business) if params[:src_id]

    if @reminder.save
      render json: @reminder, status: :created
    else
      render json: @reminder.errors, status: :unprocessable_entity
    end
  end

  def task_view
    @reminder = current_business.reminders.find(params[:id])
    render json: @reminder, status: :ok
  end

  def task_update
    @reminder = current_business.reminders.find(params[:id])
    @reminder.update(reminder_params)
    @reminder.update(repeats: nil) if @reminder.repeats.blank?
    # skip_occurence(current_business) if params[:src_id]

    if @reminder.save
      render json: @reminder, status: :ok
    else
      render json: @reminder.errors, status: :unprocessable_entity
    end
  end

  private

  def reminder_params
    params.permit(:body, :remind_at, :end_date, :repeats, :end_by, :repeat_every, :repeat_on, :on_type, :description)
  end
end
