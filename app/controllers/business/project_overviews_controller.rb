# frozen_string_literal: true

class Business::ProjectOverviewsController < ApplicationController
  prepend_before_action :authenticate_user!
  before_action :require_business!
  before_action :find_project_and_specialist

  def show
    respond_to do |format|
      format.html do
        Project::Decorator.decorate(@project).tap do |project|
          render partial: 'projects/dashboards/project_overview', locals: { project: project, specialist: @specialist }
        end
      end
    end
  end

  private

  def find_project_and_specialist
    @project = current_business.projects.find(params[:project_id])
    @specialist = Specialist.find(params[:specialist_id]) if params[:specialist_id]
    @specialist = nil if @specialist.present? && @specialist.applied_projects.where(id: @project.id).blank?
  end
end
