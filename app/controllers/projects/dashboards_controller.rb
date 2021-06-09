# frozen_string_literal: true

class Projects::DashboardsController < ApplicationController
  prepend_before_action :find_project, only: :show
  prepend_before_action :require_specialist!
  before_action :redirect_if_full_time
  # skip_before_action :check_unrated_project, if: -> { action_name == 'show' && @project&.requires_specialist_rating? }

  def show
    # rubocop:disable Style/GuardClause
    if @project.rfp?
      applications = @project.job_applications.where(specialist_id: current_specialist.id)
      @project.populate_rfp(applications[0]) if applications.count.positive?
    end
    # rubocop:enable Style/GuardClause
  end

  private

  def redirect_if_full_time
    redirect_to specialists_dashboard_path if @project&.full_time?
  end

  def find_project
    projects = current_specialist.projects.where(id: params[:project_id])
    projects = current_specialist.applied_projects.where(id: params[:project_id]) if projects.blank?
    @project = projects.first
  end
end
