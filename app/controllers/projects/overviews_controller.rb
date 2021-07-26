# frozen_string_literal: true

class Projects::OverviewsController < ApplicationController
  before_action :require_specialist!
  before_action :find_project

  def show
    respond_to do |format|
      format.html do
        Project::Decorator.decorate(@project).tap do |project|
          render partial: 'projects/dashboards/project_overview', locals: { project: project }
        end
      end
    end
  end

  private

  def find_project
    if current_specialist.applied_projects.where(id: params[:project_id]).present? || current_specialist.projects.where(id: params[:project_id]).present?
      @project = Project.find(params[:project_id])
    end
  end
end
