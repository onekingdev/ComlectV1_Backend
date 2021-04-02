# frozen_string_literal: true

class Api::ProjectIssuesController < ApiController
  before_action :require_someone!
  before_action :find_project

  def create
    @issue = ProjectIssue::Create.(@project, issue_params.merge(user_id: current_user.id))
    if @issue.persisted?
      respond_with @issue
    else
      respond_with(@issue.errors, status: :unprocessable_entity)
    end
  end

  private

  def find_project
    @project = @current_someone.projects.preload_association.find(params[:project_id])
  end

  def issue_params
    params.permit(
      :issue
    )
  end
end
