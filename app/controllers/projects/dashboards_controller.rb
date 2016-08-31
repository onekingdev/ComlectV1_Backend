# frozen_string_literal: true
class Projects::DashboardsController < ApplicationController
  prepend_before_action :find_project, only: :show
  prepend_before_action :require_specialist!
  skip_before_action :check_unrated_project, if: -> { action_name == 'show' && @project&.requires_specialist_rating? }

  private

  def find_project
    @project = current_specialist.projects.find(params[:project_id])
  end
end
