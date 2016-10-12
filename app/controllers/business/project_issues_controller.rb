# frozen_string_literal: true
class Business::ProjectIssuesController < ApplicationController
  before_action :require_business!
  before_action :find_project

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @issue = ProjectIssue::Create.(@project, issue_params)
    respond_to do |format|
      format.js do
        render :new unless @issue.persisted?
      end
    end
  end

  private

  def issue_params
    params.require(:project_issue).permit(:issue, :desired_resolution).merge(user_id: current_user.id)
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
