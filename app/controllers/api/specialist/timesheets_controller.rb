# frozen_string_literal: true

class Api::Specialist::TimesheetsController < ApiController
  before_action :require_specialist!
  before_action :find_project

  def index
    timesheets = @project.timesheets.sorted
    respond_with paginate(timesheets), each_serializer: TimesheetSerializer
  end

  def show
    timesheet = @project.timesheets.find(params[:id])
    respond_with timesheet, serializer: TimesheetSerializer
  end

  def create
    authorize @project.timesheets.new
    timesheet = @project.timesheets.create(timesheet_params)
    if timesheet.errors.any?
      respond_with errors: timesheet.errors, status: :unprocessable_entity
    else
      Notification::Deliver.timesheet_submitted!(timesheet) if timesheet.submitted?
      respond_with timesheet, serializer: TimesheetSerializer, location: nil
    end
  end

  def update
    timesheet = @project.timesheets.find(params[:id])
    authorize timesheet, :update?
    if timesheet.update(timesheet_params)
      Notification::Deliver.timesheet_submitted!(timesheet) if timesheet.submitted?
      respond_with timesheet, serializer: TimesheetSerializer
    else
      respond_with errors: timesheet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    timesheet = @project.timesheets.find(params[:id])
    authorize timesheet, :destroy?
    if timesheet.destroy
      respond_with timesheet, serializer: TimesheetSerializer
    else
      head :bad_request
    end
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(
      :status,
      time_logs_attributes: %i[id description hours date]
    )
  end

  def find_project
    @project = current_specialist.projects.find(params[:project_id])
  end
end
