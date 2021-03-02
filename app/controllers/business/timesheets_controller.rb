# frozen_string_literal: true

class Business::TimesheetsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!
  before_action :find_project

  def index
    render html: content_tag(
      'timesheets-show-page',
      '',
      ':project': @project.to_json,
      ':timesheets': @project.timesheets.sorted.not_pending.to_json
    ).html_safe, layout: 'vue_business'
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
