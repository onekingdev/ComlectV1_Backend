# frozen_string_literal: true

class Business::TimesheetsController < ApplicationController
  before_action :require_business!
  before_action :find_project

  def index
    @timesheets = @project.timesheets.sorted.not_pending
    respond_to do |format|
      format.html { render partial: 'index' }
      format.js
    end
  end

  def show
    @timesheet = @project.timesheets.find(params[:id])
  end

  def update
    timesheet = @project.timesheets.find(params[:id])
    authorize timesheet, :process?
    @timesheet = Timesheet::Form.process(timesheet, timesheet_params)
    render :show
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:approve, :dispute)
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
