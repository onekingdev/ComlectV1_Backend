# frozen_string_literal: true
class Projects::DashboardsController < ApplicationController
  before_action :require_specialist!

  def show
    @project = current_specialist.projects.find(params[:project_id])
  end
end
