# frozen_string_literal: true
class Projects::JobApplicationsController < ApplicationController
  before_action :require_specialist!
  before_action :find_project

  def new
    @job_application = @project.job_applications.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @job_application = JobApplication::Form.apply!(current_specialist, @project, job_application_params)
    respond_to do |format|
      format.js do
        if @job_application.persisted?
          js_redirect project_path(@project)
        else
          render :new
        end
      end
    end
  end

  private

  def job_application_params
    params.require(:job_application).permit(:message)
  end

  def find_project
    @project = Project.published.pending.find(params[:project_id])
  end
end
