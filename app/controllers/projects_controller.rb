# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!, only: %i(new create edit update)

  def new
    @project = current_user.business.projects.new
  end

  def create
    @project = current_user.business.projects.new(project_params)
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:title)
  end
end
