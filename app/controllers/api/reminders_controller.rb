# frozen_string_literal: true

class Api::RemindersController < ApiController
  include RemindersUpdater
  include RemindersFetcher

  before_action :require_someone!
  # before_action :authorize_action

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def by_date
    tasks, projects = tasks_calendar_grid2(@current_someone, Date.parse(params[:date_from]), Date.parse(params[:date_to]))
    render json: { tasks: ActiveModel::Serializer::CollectionSerializer.new(tasks), projects: projects }
  end

  def overdue
    render json: { tasks: reminders_past(@current_someone) }
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.remindable_id = @current_someone.id
    @reminder.remindable_type = @current_someone.class.name.split('::').first
    @reminder.repeats = nil if @reminder.repeats.blank?
    @reminder.skip_occurencies = []
    @reminder.done_occurencies = {}
    # skip_occurence(@current_someone) if params[:src_id]
    if @reminder.save
      render json: @reminder, status: :created
    else
      render json: { errors: @reminder.errors }, status: :unprocessable_entity
    end
  end

  def show
    @reminder = @current_someone.reminders.find(params[:id])
    render json: @reminder, status: :ok
  end

  def destroy
    @reminder = @current_someone.reminders.find(params[:id])
    if params[:oid]
      @reminder.update(skip_occurencies: @reminder.skip_occurencies + [params[:oid].to_i])
    else
      @reminder&.destroy
    end
  end

  def update
    @reminder = @current_someone.reminders.find(params[:id])
    change_reminder_state if params[:done].present?
    @reminder.update(reminder_params)
    @reminder.update(repeats: nil) if @reminder.repeats.blank?
    skip_occurence(@reminder) if params[:oid]

    if @reminder.save
      render json: @reminder, status: :ok
    else
      render json: @reminder.errors, status: :unprocessable_entity
    end
  end

  private

  def reminder_params
    params.permit(:body, :remind_at, :end_date, :repeats, :end_by, :repeat_every,
                  :repeat_on, :on_type, :description, :linkable_id, :linkable_type, :assignee_type, :assignee_id)
  end
end
