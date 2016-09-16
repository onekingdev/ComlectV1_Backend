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
    @issue = @project.issues.new(issue_params)
    if @issue.save
      ProjectMailer.escalate(@issue).deliver_later
      respond_to do |format|
        format.js { render(:new) }
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
