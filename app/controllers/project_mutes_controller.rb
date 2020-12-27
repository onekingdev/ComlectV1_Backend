# frozen_string_literal: true

class ProjectMutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def toggle
    muted_or = 'muted'
    if current_user.muted_projects.include?(@project.id)
      muted_or = 'unmuted'
      current_user.update(muted_projects: current_user.muted_projects - [@project.id])
    else
      current_user.update(muted_projects: current_user.muted_projects + [@project.id])
    end
    path_to = current_user.business ? business_dashboard_path : specialist_dashboard_path
    
    redirect_to path_to, notice: "Project is #{muted_or}: #{@project.title}"
  end

  private

  def set_project
    @project = if current_user.business
                 current_user.business.projects.find(params[:id])
               else
                 current_user.specialist.projects.find(params[:id])
               end
  end
end
