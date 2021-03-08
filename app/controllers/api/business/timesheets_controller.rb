# frozen_string_literal: true

class Api::Business::TimesheetsController < ApiController
  before_action :require_business!
  before_action :find_project

  def index
    timesheets = @project.timesheets.sorted.not_pending
    respond_with paginate(timesheets), each_serializer: TimesheetSerializer
  end

  def show
    timesheet = @project.timesheets.find(params[:id])
    respond_with timesheet, serializer: TimesheetSerializer
  end

  def update
    timesheet = @project.timesheets.find(params[:id])
    authorize timesheet, :process?

    if timesheet_params[:dispute] == '1'
      timesheet.disputed!
      Notification::Deliver.specialist_timesheet_disputed! timesheet
      @project.update(:ends_on, @project.ends_on + 1.day) if @project.past_ends_on?
    end

    if timesheet_params[:approve] == '1'
      timesheet.approved!
      @project.time_logs.update_all hourly_rate: @project.hourly_rate
      @project.time_logs.update_all 'total_amount = hourly_rate * hours'
    end
    respond_with timesheet, serializer: TimesheetSerializer
  end

  private

  def timesheet_params
    params.permit(:approve, :dispute)
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
