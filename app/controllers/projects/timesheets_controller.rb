# frozen_string_literal: true

class Projects::TimesheetsController < ApplicationController
  before_action :require_specialist!
  before_action :find_project

  def index
    @timesheet = Timesheet::Form.new_for(@project)
    @timesheets = @project.timesheets.sorted
    respond_to do |format|
      format.html { render partial: 'index' }
      format.js
    end
  end

  def show
    @timesheet = @project.timesheets.find(params[:id])
  end

  def new
    @timesheet = Timesheet::Form.new_for(@project)
  end

  def create
    authorize @project.timesheets.new
    @timesheet = Timesheet::Form.create(@project, timesheet_params)
    @timesheets = @project.timesheets.sorted.page(params[:page]).per(5)

    if @timesheet.errors.any?
      render :new
    else
      render status: :created
    end
  end

  def edit
    @timesheet = @project.timesheets.find(params[:id])
    render :show unless policy(@timesheet).edit?
  end

  def update
    @timesheet = Timesheet::Form.update(@project.timesheets.find(params[:id]), timesheet_params)
    return render(:edit) if @timesheet.errors.any?
    policy(@timesheet).edit? ? render(:edit) : render(:show)
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:save, :submit, time_logs_attributes: %i[id description hours _destroy date])
  end

  def find_project
    @project = current_specialist.projects.find(params[:project_id])
  end
end
