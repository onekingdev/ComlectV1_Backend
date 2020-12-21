# frozen_string_literal: true

class Projects::ProjectEndsController < ApplicationController
  before_action :require_specialist!
  before_action :find_project

  def update
    return render_404 unless @project.end_requested?
    ProjectEnd::Request.confirm_or_deny!(@project, params.slice(:confirm, :deny))
    js_redirect project_dashboard_path(@project)
  end

  private

  def find_project
    @project = current_specialist.projects.preload_association.find(params[:project_id])
  end
end
