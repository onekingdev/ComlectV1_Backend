# frozen_string_literal: true

class Business::ProjectDashboardController < ApplicationController
  prepend_before_action :find_project, only: :show
  prepend_before_action :require_business!
  before_action :redirect_if_full_time
  skip_before_action :check_unrated_project, if: -> { action_name == 'show' && @project&.requires_business_rating? }

  private

  def redirect_if_full_time
    redirect_to business_dashboard_path if @project&.full_time?
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
    @specialist = Specialist.find(params[:specialist_id]) if params[:specialist_id]
    if !@specialist.blank?
      @specialist = nil if @specialist.applied_projects.where(id: @project.id).blank?
    end
  end
end
